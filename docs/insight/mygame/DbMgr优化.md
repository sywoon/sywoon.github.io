

## 游戏内测分析

- window对象 55M
```
    sg 20.8M
      dbmgr 20.6M
        _configData 20.6M
          skill_skill:object 4M
          monster_monster: 2M
    Proto 1M
      properties 0.98M
      cmdid：协议对象
    mvc 0.5M
      bgModel 0.6M 怎么比外层大了？ 而且内部全加也没这么大
        _bagIdMap 大量的BagItemVo 0.14M
    mgr 0.1M
```

-  Function 39M
```
  sg 20M
  Loader 7M
    loadedMap 7M
      url:object
        http:..xxx/fileconfig.json 0.2M 有大量atlas对象
        sk/0129/show.skel arraybuffer 0.15M  spine清理时 有没清这里的记录？
      properties 0.1M
        number:object arraybuffer 动态加入的对象？
```


## 优化方案

- 看看db压缩
```
dbmgr 
  原始数据6.89M  分析成vo后占20M 3倍 可一次存储着 当db需要时 再做解析 创建动态的数据
  性能可能会差些  实际很多的表本次游戏确实没用到
  ----
  登录阶段 8M
    _dataSrc 原始数据 0.2M
    _configData 8M
    改为读取某个个id数据时 才解析这个表； 可否表都比解析了 要哪行再创建哪行？ -大量临时对象 gc问题？
  新出现的问题：
    数据取不到； 原因：_parseConfigByName 第二次有数据时 返回false错了
    vtable不能用了 因为导入时 表数据都没准备；  -没这回事 这块数据暂时没法处理 只能正常解析了
    channel_exchange 这个海外平台配置奖励字段用的 也是需要一开始就解析 registerVirtualDbLine
  ---
  优化后数据表现：
  DbMgr 登录时只有3.6M  不过游戏运行后 还是会回到23M 而且还多了_srcData 6M 因为没法知道是否都解析完了
  ---
  需要进一步优化：只解析要的那行？？
```


## 未来的优化
- dbmgr 基于二进制流  字符串共用



## excel存储方式
1. 直接读 u3d有这类插件  猜测内部按zip解析  效率和内存都不佳  适合开发模式
2. 转json 或 yaml
3. 转csv 以|分割数据 比json小一点  解析会更慢
4. 自定义格式  比如项目内的heads.json data1.json data2.json  减少头部相同的字符串 内容用数组方式存储
5. 转二进制  具体规则？ 第三方插件？ 类MsgPack
6. 大表只存在服务器中，客户端分段请求

了解下大家之前项目中 或见过的别项目 或第三方插件 或文章等 关于excel存储方式的应用
不论引擎类型laya u3d cocos...
补充下所有的可能的解决方案 集思广议：
1. 直接读excel   是否有见过？
[js-xlsx](https://blog.csdn.net/u014241231/article/details/122615830) 
2. 转json
3. 转csv 以|分割数据 比json小一点  解析会更慢
4. 二进制  规则？ 插件？
5. 用zip压缩的原理  将字符串归类到一个对象数组中 所有字符串用索引方式 解析时替换回去



## DbMgr分析

### 原始素材
- res\db_pre
```
  都是取名表 由于dbmgr加载常规表比较慢 将登录需要的表提前分离出来
  nameList.json
  nameListEn.json
  nameListTw.json
  
  LoginModel.loadNameDb()
  	Laya.loader.load(file, Laya.Handler.create(this, this._onNameDbLoaded, [file]));
  	
	private _onNameDbLoaded(file) {
    let db = Laya.loader.getRes(file);
    this._cfgNameDb = {db:db}

  直接内部封装了名字读取 不再走dbmgr
	getNewName(isMan:boolean): string {
```

- tools/data/extend_data.json
```
  某个表的 2个或以上字段 映射到唯一id
  "beast_upStar" : {
        "keys_map": [
            [["beastId", "star"], "id"]
        ]
    },
```

- res\db\heads.json
```
  tables:["activity", "bag"]  所有的表名 确定表的索引 后续都和这对应
  heads_type:[[0,1,1],[0,2,2]] 0:int 1:string 2:json
  heads:[[id,name],[id,condition]] 每个表的表头 
  double_keys:{  映射表 包含了表名 数据-内容从工具的extend_data.json生成
    "beatGame_treasure":{"1001_1":1,"1001_2":2,}
  	"beatGame_weapon":{"2001_1":1,"2001_2":2
  	注意：内容比较大  是否可优化？
  file_num:2  data.json的个数
```

- res\db\data1.json data2.json
```
  只有一样数据
  values:[ [[101, "aa"],[第二行数据]], [表2]]
```

- DbConfig.ts
```
	export let DB_CONFIG = {
        vtable: {
            // 虚拟表  以v开头
            vitem: [
                "item_matrixSymbol", //阵符
                "suit_suitEquip",     //套装装备
		//其他语言 奖励列映射表 reward_ko => reward上 这样业务不用修改
        reward2platformExcel: "channel_exchange"
```


- 构造对象
```
  _configData={} 存放某个表的具体对象 
    [name]=object-是一个map对象  表名 ： 解析后的表对象
      [id]={id:1, name:"a", age:1} 从原始数据解析而来的map对象 -最大的内存部分！
      [key1_key2]=id  多个key映射到某个id
    [vtable] = object 将多个虚拟表 合并为一个大表
      要求：id唯一 
      object内的数据 实际就是上面每个表的所有map对象汇总 多了一份引用 不会增加内存
      但依赖前置解析
      
  _dataSrc = {head:head, dataUrls:{res/db/data1.json,..2.json},
  	values:values}  values是所有data.json的合集 整个大数组 按head的顺序保存
  _loadedAll:boolean 控制是否下载完 作为流程继续回调的标记
  _parsedAll:boolean 是否分析完 不同的分析模式
  _dbParseMode:number 分析模式 0完整 1分阶段
```
- init
```
  sg.init
  static init(cbk: Function): void {
  	sg.dbmgr.init(loadCall);  最初要等data.json下载解析完 才继续后续流程
  	体验不好 改为立刻完成
  	
```

- loadConfig(parseMode:number = 0)
```
  SysLogin.onAwake()SysLogin.onAwake()
   sg.dbmgr.loadConfig(sg.DbMgr.PARSE_MODE_STEP); 登录界面起来后 再加载
```

- 下载顺序
```
  _loadDbHead() => _onLoadDbHead 先保存this._dataSrc = {head: head};
  _loadDbBody() => 多个data一次调用_dataSrc.dataUrls = urls;
  =》  _onLoadDbBody 若失败 重新下载body 将所有数据合并
    this._dataSrc.data = data.values.concat(subData.values);
  =》 根据_dbParseMode 判断是否立刻全部解析
    if (!this._parseDbAll()) { 若失败 从loadhead重新开始
  =》无论哪种　都会走到_onloadedAll();
  	清理下载缓存　Laya.loader.clearRes(DB_PATH_HEAD + ".json");
  	若完整模式　清理delete this._dataSrc;
  	_loadedAll = true 并回调 this._loadedAllCbk();
```

- 表的解析
```
  _parseDbAll() {  
    for (let name of head.tables) {
      if (!this._parseConfigByName(name))

  _parseConfigByName(name: string) { 单个表
	 let idxT = tables.indexOf(name);
	 this._makeOneTable(name, heads[idxT], values[idxT]);
	 将映射内容写入 同一个表对象中
	 let config = this._configData[name];
        let maps = double_keys[name];
        for (let key in maps) {
            config[key] = maps[key];
        }

  _makeOneTable(name: string, head: any, data: any) {
    let config = {};  每行map数据汇总到一个表中 
  	for (let i = 0; i < data.length; i++) {
        let line = data[i];
        config[line[0]] = this._makeTableLine(head, line);
    this._configData[name] = config;

  单行数组数据 转map  内存会变大  
  _makeTableLine(head: any, line: any) {
    let map = {};
        for (let i = 0; i < head.length; i++) {
            map[head[i]] = line[i];
```

- 虚拟表
```
  registerVirtualDb(config: any)
    所有需要合并的表 读取出来 合并到一个对象中 再存储到虚拟名称里
    这里是改为动态生成数据最大的卡点！ 他需要所有数据都已经在内存中
    for (var vname in config) {
        data = {};
        let arr = config[vname];
        for (var name of arr) {
            sg.Object.assignTo(this.getDB(name), data);
        }
        this._configData[vname] = data;
```

- 数据的读取1 get
```
  get(name: string, id: string
    按需解析单个表
    if (!this._parsedAll && !this._parseConfigByName(name)) {
    	return
    let cnf = this._configData[name];
    return cnf[id]  得到表map中的某行数据 已经根据表头合转换一个map 
```

- 读取2 getUnique
```
  转唯一key 先映射到id 再映射到某一行
  getUnique(name: string, ...args): any {
    let arrParams = Array.prototype.slice.call(args);
    let key = arrParams.join("_");
    let id = this.get(name, key);  //双重关联
    return this.get(name, id)
```

- 读取3:getArray
```
  遍历表 再根据满足条件的行 单独存储
  getArray(name: string, data: any
  	let config = this._configData[name];
  	for (let id in config) {
      let info = config[id];
```

- 读取4:filter
```
  filter(name: string, call: Function)
  	类似getArray 过滤的方式改为函数

  filterLine(name: string, call: Function)
    获取第一条满足的数据
```

- 读取5：getDB
```
  读取整个表 一种原始map方式放回 另一种 每一行数据添加到数组中-为了方便业务遍历
  getDB(name: string, isArray
```


## DbMgr按行解析优化方案
1. 动态分析分为：按表 + 按行
	- 表：getArray getDb filter filterLine  
		- 优化：不允许使用vtable  太大
	- 行：get getUnique 
		- 优化：按行解析 而非原来的按表
2. 分析函数
	- 表：_parseConfigByName(name)
	- 行：_parseOneLineConfigById(name, id)
		- 内部兼容虚拟表：若是vtable 再次根据id细分到具体的某个表
	- 行2：_parseOneLineConfigByIdReal(name, id) 不含虚拟表 真实的表
		- 得到表的head和data数据
	- 行3：_makeOneLineData(name: string, head: any, data: any, id: string)
		- 存储一份id到idx的映射 this._configData[name]["id_to_idx"]
		- 解析出这一行 并记录 this._configData[name][id] = lineMap;
3. 虚拟表注册registerVirtualDb 
	- 若是动态模式 不再立刻分析 按上面的逻辑走
4. 加载表后的解析
	- 同上
5. double_key不用处理 因为是同一个表  对应getUnique(name: string, ...args)
	- 先通过多列的数据 用'_'拼接为一个key 再映射到具体id
	- 通过id取数据行 可以复用get逻辑 无需特殊处理
	- 注意：
	- a. 加载时机有调整  原在所有表解析后处理  先改为getUnique中处理
	- b. 虚拟表正常不能有这种映射 !!
	- 优化：动态模式 不再存入具体的表里 单独存放到head.double_keys getUnique读取时先从这里得到id 
6. 单表数据的判断 if (this._configData[name]) 这个逻辑在动态情况不再成立
	- 可能有单条数据  动态解析存入的
	- double_key数据  



## 问题记录
1. for遍历协议对象问题
```
  PropertyModel
    static praseProp(
      for(let key in attr)  //会遍历出proto的decode方法 错误进入后续流程
```

2. 用id读表 判断id不正常情况
```
  DbMgr
    get(name, id
      if (!id) console.error  这种写法有问题 因为id可以为0
      改为 if (id == undefined || id == null)

  UnitChatIcon
    _initChatShow() {
      定位到parent是sys_main.box 所以没有“configName”属性  应该是一开始就配置在ide中的
      let show = sg.dbmgr.get("chat_show", this.parent["configName"]);

  GPlatform
    isShowRecharge(funcId = 0, productID = 0)
    	gear表不存在为0的情况 添加productID>0判断
    	let data = productID>0 ? sg.dbmgr.get("recharge_gear", productID) : null;
    	
    	
  ActivityModel
    后台活动
    public getFuncopenIdByActType(actType: number) {
        return this._activityTofuncOpen.get(actType) || 0;

    createAndAddBgActivityVo(v: Proto.bg_activity_p, isWill: boolean)
      劳动节协助活动 type：10026
      let funcOpenId = this.getFuncopenIdByActType(v.type);
      竟然没取到 导致openId=0  后续读funcOpen表时报错 没这行数据
```

3. getId 和 getDB 冲突
```
  若先调用了一次get 则config中会存储一份表的数据 但只有一行
  get(name, id, noTrans = false) {
    if (!this._parsedAll && !this._parseOneLineConfigById(name, id)) 	

  下次获取整个数据时 
   getDB(name, isArray = false) {
        if (!this._parsedAll && !this._parseConfigByName(name)) {

  ActivityModel
    initAllCfg()
      写入后台活动时出问题 这里只得到一条数据的表
      let cfgs = sg.dbmgr.getDB(ActivityConst.funcOpen);
        for (let key in cfgs) {
            let cfg = cfgs[key];
            if (cfg.bgType) {
                this._activityTofuncOpen.set(cfg.bgType, cfg.id);
  解决：加一个标记位 表示整个表被解析过 而非通过if (this._configData[name])判断
```

4. id读取不到
```
  PetModel
    atlasRedByType(type) {
		let petcfg = sg.dbmgr.get("pet_pet", cfg.petId); 1001
		if (this.getPetAtlasByRaceAndQuality(petcfg.class, cfg.quality))
    
    10001	青龙   表里没这个数据
    getPetAtlasByRaceAndQuality(id: number, quality: number)
    	let cfg = sg.dbmgr.get("pet_petAtlas", id);
```


## 数据结果分析
- 旧版本
```
  DbMgr 20.8M
    _configData 20.8M
      skill_skill  4.1M
      vitem  4.0M
      monster_monster 2.0M
```

- 新版本
```
  DbMgr 17.8M  可节省3M 主要原始数据就很大  取消idtoidx后 17.1M 省3.7M
    _dataSrc 13.7M
      data 13.7M
        values   通过sg.dbmgr._dataSrc.head.tables[355]定位表名
         [355] 3.3M vitem表 具体哪个？ suit_suitEquip 有大量相同字符串
         [210] 1.9M monster_monster  366k 也有大量数组 这东西看了很占空间 是个object  优化成int32buffer？
         [313] 1.3M skill_skill  693k
         [359] 0.9M swordGame_barrierSet 表只有95K 但有很多数组
         [311] 0.9M skill_buff  510K
    _configData 1M 主界面孵了几个蛋
    _idtoidx  0.98M   说明大量小map也占用内存  优化掉 不要了
```

- 压缩字符串版本 可节省4.4M
```
  原始数据
  oldJson 16.1M
  data1.json 9.9M
    [213] 1.9M
    [317] 1.3M
    [315] 0.87M
  data2.json 5.9M
    [0] 3.3M
    [4] 0.8M
    
  
  压缩数据：相同字符串合并
  newJson 11.7M
  data1.json 6.2M
    [213] 1.3M
    [317] 0.6M
    [315] 0.3M
  data2.json 4.0M
    [0] 1.7M
    [4] 0.89M
```


## 优化结论
1. 改为动态加载 省3.7M 实际效果一般 因为原始数据就很大 需要改为二进制方式才能发挥它的用处 
2. 相同字符串压缩  省4.4M 
3. js中原生的动态数组 动态object对象都非常大 比float32array int32array大很多  
4. proto对象 在for in遍历中 会将decode方法带出来 可用 data.ownerProperty("name")来排除









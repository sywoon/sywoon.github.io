# 🔙​[心得汇总](/docs/insight/)

# 腾讯游戏云技术闭门会议

2024.5.30 下午  海珠区tit创意园会议中心



## 1. aigc技术在游戏中的应用
殷俊 腾讯互娱研发效能部游戏ai技术总监

1. Game Air 训练的机器人用于不同的游戏 英雄联盟、和平精英在用；对抗 陪玩 高度模拟人性
2. Aivatar 智能角色制作：自动蒙皮 语音转脸部动作 
3. Aibrain 智能npc：基于llm和基于深度强化学习两条生产管线
4. Aispace 海量资源 嵌入3dmax  更加描述的场景 智能提取和组合
5. ArtHub  资源管理  环境统一搭建 在线浏览 权限管理 美术ddc工具管理Blade
6. AutoLUV 一键出光照uv图 接近人工水准


## 2.小游戏出海
孙晨阳 cocos引擎运营总监

1. youtube tiktok海外小游戏； 
2. 自买量使用adsense变现
3. 流量向手机倾斜：poki crazygame game_distribution
4. cocos和google合作，上线了google adsense插件，一键发布到google平台；已有30款游戏
5. cocos上线了大部分流量平台sdk：
	- crazygame：pc用户多 56%男性 喜欢休闲和动作游戏 品质要求高
	- poki：手机用户超过50% 53%为女性 喜欢高品质休闲游戏 换皮类上架难
	- dmm：男性80% 中重度练级对战
6. 新的平台：youtube小游戏 discord小游戏-基于discord服务器，联机方便；adsense 欧洲alt store
7. 


## 3.游戏研发ai赋能及产品创新落地分享
刘小青  诗悦基础架构负责人

1. ai流失预测：基于数据流 事实预测流失率、找到流失的人群、定位流失人群
	监控前30天用户样本：活跃度特征、重置特征、玩法和社交特征，预测后15天的流失
2. 运维和安全：回档 监控 代码安全 财务监控；闲置回收、成本合理评估
3. 研发管线：svn资源管理 版本更新 内部包管理 敏感词 存储监控
4. 策划运营：ai战斗平衡性车速 舆情监控 ai流失预测 广告识别



## 4. ai agent在codereview中的技术实践
杨杰 三七互娱平台架构师

1. 研发流程：技术方案-》代码开发-》自动车速+codereview=》qa车速-》上线发布
2. 自动测试：lint 静态代码分析 单元车速 集成车速
3. lint：静态代码分析器：语法 编码标准 代码复杂度 安全检查
4. 其他静态分析器：Perforce静态代码分析器可检查代码是否存在严重的编码违规；Helix QAC和Klocwork也可以做到
5. ai codereview流程：开发git提交-》gitlab通过webhook监控：获取代码=》上下文填充=》安全风控=》模型筛选=》请求模型=>消耗计费 -》审核建议返回给gitlab -》审核提示 通过web给开发查看





















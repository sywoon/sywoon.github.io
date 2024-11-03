

# js异步调用进化史


## 1.回调函数
 f1(cbk)

## 2.事件通知
某个具体对象上注册监听事件
  f1.on("evt_name", cbk)
  f1.fire("evt_name")

## 3.发布/订阅中心
  有一个独立的center 统一管理所有事件的订阅
  优点：可以监控当前游戏的所有状态
  缺点：
    a 所有事件都混在中心 一旦某个逻辑把中心搞挂了 整个游戏瘫痪 try可否解决？
    b 不好查bug 事件太多 一直在变动
    c 事件残留 不容易被发现  变成垃圾事件 - 只订阅 忘了取消
```js
  center.on("evt_name", cbk)
  center.call("evt_name")
```

## 4. Promise es2015中引入 
根据项目使用情况 目前所有的环境都已经支持
```js
{
    let p = new Promise((resolve, reject) => {
        console.log("start promise");
        // resolve("resolve");  若开启 则后续reject不会执行 因为只能有一次状态切换
        reject("reject");
    });

    p.then(
        value => {
            console.log("Resolved: " + value);
        },
        reason => {
            console.log("Rejected: " + reason);
        }
    )
    p.catch(reason => {
        console.log("catch: " + reason);
    });
}
```
- 分析：
1. Promise对象构造时 传入一个主体函数；当调用then时，会执行这个函数，同时附带关键参数resolve和reject
2. 主体函数执行过程中，可随时终止函数执行，并通过resolve或reject来把结果传出
3. Promise只有3种状态：等待pending 已完成fullfilled 已拒绝rejected，所以主体函数一旦中途调用了resolve或reject都表示这个promise结束了,不会再继续执行
4. .then(resolveCall, rejectCall) 可获取主体函数分别在成功/失败下的执行的结果
5. new Promise后 必然会执行主函数-但是会延迟执行；若内部只有resolve或正常结束，则没问题；
   若内部reject了，但是外部没有then 也没有catch，会报错UnhandledPromiseRejection 
6. 若调用reject 同时有then和catch的情况 两者会同时调用； 谁写在前面 谁先调用
7. catch 是一个方法，用于捕获 Promise 中的错误。它可以捕获由 reject 触发的错误，也可以捕获在 then 回调函数中抛出的错误
8. reject：在 Promise 执行过程中，用于标识操作失败，并传递错误信息


- 缺点：
1. 无法从外部提前终止promise的执行 不像c#的协程 而可以terminal
2. Promise的内部错误使用try catch捕获不到，只能只用then的第二个回调或catch来捕获


- 注意：then中的回调 速度晚于generator 更像游戏中的下一帧回调


### Promise中的错误抓取
```js
{
    let pro
    try {
        pro = new Promise((resolve, reject) => {
            try {
                throw Error('err....')
            } catch (err) {   若内部有catch 则结束 且外部catch then都接受不到
                console.log('promise err inside', err) 
            }
            return "normal end"
        })
    } catch (err) {
        console.log('catch', err) // 不会打印
    }
    pro.catch(err => {
        console.log('promise', err) // 会打印
    })
  若内部有catch 则结束 且外部catch then都接受不到
  return 并不能把数据传出来！！
}
```

```js
{
    let pro
    try {
        pro = new Promise((resolve, reject) => {
            throw Error('err....')
            console.log('promise before return')
            return "normal end"
        })
    } catch (err) {
        console.log('catch', err) // 不会打印
    }

    pro.then(data => {
        console.log('promise then', data)
    }, 
    err => {
        console.log('promise reject err', err)
    })
    pro.catch(err => {
        console.log('promise catch', err)
    })
  1. Promise本身不能共用try抓取
  2. 可以在内部try 或.then .catch方式抓取
```




## 5. Generator函数 Es2015
和lua的协程非常像 yield和nex他对应yield和resume 数据传递方式也一样
```js
    function* foo(x) {
        let y = 2 * (yield (x + 1));
        let z = yield (y / 3);
        return (x + y + z);
    }

    let it = foo(5);
    console.log(it.next()); // => {value: 6, done: false}
    console.log(it.next(12)); // => {value: 8, done: false}
    console.log(it.next(13)); // => {value: 42, done: true}

    console.log(it.next(14)); // => { value: undefined, done: true }
    console.log(it.next(15)); // => { value: undefined, done: true }
```
- 分析：
1. 构造函数 返回一个迭代器 保存了初始参数
2. 第一次next() 没有内容传入-给了也无用，会被忽略；会用构造中的参数，执行generator主函数
3. 主体内部，第一次yield，将(x+1)内的的计算结果 返回给外部，用log输出
4. 第二次next(12) 输入的参数，会代签主体内刚才yield的位置 得到y=2*12
5. 后续同理，直到return返回 得到最后一次next的值，并且通过返回对象的done标记，可知道主体函数是否结束了
6. done之后 再调用next 并不会报错，得到undefined值

- 缺点：同上无法提前终止


## 6. Async Await Es2017
经过项目验证 也全部支持了 再不济也可用babel转es5

- 优点：
  更容易调试 使用简单
  集合了generator next和promise的功能


### 通过async获取函数返回值
```js
async function read(x) {
  return x + 1;
}

read(2).then(console.log); // 3
```
- 分析：
1. async函数调用后会得到一个Promise对象 通过then，就可以获得函数的返回值
2. async可理解为 return new Promise((resolve, reject) => {})


### async内使用await 达到异步等待目的
```js
function read3(x) {
    return Promise.resolve(x + 1);
}

function read2(x) {
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            resolve(x + 1);
        }, 1000);
    });
}

async function call(x) {
    let w1 = await read2(x);
    console.log("w1", w1)

    let w2 = await read3(w1);
    console.log("w2", w2)
}

call(1).then(
    data => {
        console.log("then", data)
    },
    err => {
        console.log("error", err)
    }
)
等待1秒
w1 2
w2 3
```
- 分析：
1. await若等的是一个promise会挂起后续代码 等promise的返回
2. 若返回resolve则继续后续代码 若返回reject则结束主async函数 
3. then中可获得两种情况的返回值 

- 优点：
1. 通过reject可终止主体函数


- demo2:
```js
function read3(x) {
    return Promise.reject(x + 1);
}

function read2(x) {
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            resolve(x + 1);
        }, 1000);
    });
}

async function call(x) {
    let w1 = await read2(x);
    console.log("w1", w1)

    let w2 = await read3(w1);
    console.log("w2", w2)  这里不会执行
}

call(1).then(
    data => {
        console.log("then", data)
    },
    err => {
        console.log("error", err)
    }
)
w1 2
error 3
```
- 分析：一旦await内的函数reject或Error后 主async函数结束并停止后续的执行
- 可以用这个特性 来终止主函数



## 7. 基于async await 模拟战斗业务需要的异步调用
模拟场景：双方入场=》初始buff=》大回合=》小回合=》a攻击b =》
  b攻击a =》 b死亡消失=》游戏结束

```js
使用async功能 作为战斗主体函数的调用
使用await等待一个Promise时 会挂起 直到内部resolve或reject或Error调用 才会继续的特性
  来实现战斗的不同表现阶段
function queueInBattle() {
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            resolve('queue in battle');
        }, 1000);
    });
}

function aAttackb() {
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            resolve('a attack b');
        }, 1000);
    });
}

function battleEnd() {
    return new Promise((resolve, reject) => {
        setTimeout(() => {
            resolve('battle end');
        }, 1000);
    });
}

// 主战斗函数
async function runInBattle() {
    let rtn1 = await queueInBattle();
    console.log(rtn1);

    let rtn2 = await aAttackb();
    console.log(rtn2);

    let rtn3 = await battleEnd();
    console.log(rtn3);
    return 'runInBattle end';
}

runInBattle().then((res) => {
    console.log(res);
})
将各个业务功能的Promise的创建 可以抽取出来

function promiseCall(f) {
    return new Promise((resolve, reject) => {
        f(resolve, reject);
    });
}
```



### 一个意外的案例
```js
function promiseCall(f) {
    console.log('promiseCall()');
    return new Promise((resolve, reject) => {
        f(resolve, reject);
    });
}

function call1() {
    console.log('call1()');
    return promiseCall((resolve, reject) => {
        setTimeout(() => {
            resolve('call1 end');
        }, 1000);
    });
}

async function runInAsync() {
    console.log('runInAsync start');

    let rtn1 = await promiseCall(call1);
    console.log("await1", rtn1)

    return 'runInAsync end';
}

runInAsync().then((result) => {
    console.log("result", result);
}).catch((err) => {
    console.error("error", err);
});
无意间写错了代码了 运行结果很奇怪
runInAsync start
promiseCall()
call1()      
promiseCall()
1秒后的空行
```

- 分析：
1. 主体函数中await等call1的返回 但是call1没有使用参数 而是又套了一层promise
  所以awiat一直等不到 后续的代码也没执行
2. call1内部的promise执行返回后  会导致整个主async函数结束 且获取不到结果或错误



## 第一次封装 try await 让reject转正式调用 -中期探索
和promise不同 不能try
但可以抓await中reject的调用 将不再走外部then的err函数 而是当作resolve返回
用reject来模拟战斗提前终止  算正常功能

```js
function promiseCall(f) {
    console.log('promiseCall()');
    return new Promise((resolve, reject) => {
        f(resolve, reject);
    });
}

function call1(resolve, reject) {
    console.log('call1()');
    setTimeout(() => {
        reject('call1 end');
    }, 1000);
}

async function runInAsync() {
    try {
        console.log('runInAsync start');

        let rtn1 = await promiseCall(call1);
        console.log("await1", rtn1)
    } catch (err) {
        console.error("error inside", err);
        return 'runInAsync catch end'
    }

    return 'runInAsync end';
}

runInAsync().then((result) => {
    console.log("result", result);
}).catch((err) => {
    console.error("error", err);
});
=>
runInAsync start
promiseCall()
call1()
error inside call1 end
result runInAsync catch end
```
- 分析：
1. 主体运行后 等待call1的结束
2. call1通过reject结束 触发了主体中的catch 正常情况await会终止主体
3. catch中return 表现成和正常返回一样



## 封装：隐藏async await 新增共同变量，来存储多个函数调用的结果
```js
function runInAsync(...fns) {
    async function call() {
        console.log('runInAsync start');
        let shared = fns[0];
        for (let i = 1; i < fns.length; i++) {
            let rtn = await promiseCall(fns[i], shared);
            console.log("await:" + i+1, rtn)
        }
        console.log("await all end")
        return shared;
    }
    return call();
}

let shared = {loaded:[]}
runInAsync(shared, call1, call2).then(
    data => {
        console.log("runInAsync then", data);
    },
    err => {
        console.error("runInAsync error", err);
    }
)
```
- 分析：
1. 主体函数变成一个普通函数 返回一个async主体函数的调用，可以当做promise使用
2. 删除了之前的try封装 把reject或error重新还给外部
3. 新增的shared对象 会贯穿整个函数调用 并当做return对象 从而可以在外部的then中获取结果



## 以类的方式封装

- 简单的版本
```js
class Async {
    static _promiseCall(f, shared) {
        return new Promise((resolve, reject) => {
            f(resolve, reject, shared);
        });
    }

    run(shared, ...funcs) {
        async function call() {
            for (const f of funcs) {
                await Async._promiseCall(f, shared);
            }
            return shared;
        }
        return call();
    }

    static _promiseCallInClass(f, owner, shared) {
        return new Promise((resolve, reject) => {
            f.call(owner, resolve, reject, shared);
        });
    }

    runInClass(owner, shared, ...funcs) {
        async function call() {
            for (const f of funcs) {
                await Async._promiseCallInClass(f, owner, shared);
            }
            return shared;
        }
        return call();
    }
}
```
- 分析：
1. 提供了两种执行方式 常规：run和类函数runInClass
2. 用类的方式 方便记录状态 当前正在执行的resolve和reject



## class版本2 支持外部terminal
```js
class Async {
    constructor() {
        this.lastReject = null;
    }

    _promiseCall(f, shared) {
        let that = this;
        return new Promise((resolve, reject) => {
            that.lastReject = reject;
            f(resolve, reject, shared);
        });
    }

    run(shared, ...funcs) {
        let that = this;
        async function call() {
            for (const f of funcs) {
                await that._promiseCall(f, shared);
            }
            return shared;
        }
        return call();
    }

    _promiseCallInClass(f, owner, shared) {
        let that = this;
        return new Promise((resolve, reject) => {
            that.lastReject = reject;
            f.call(owner, resolve, reject, shared);
        });
    }

    runInClass(owner, shared, ...funcs) {
        let that = this;
        async function call() {
            for (const f of funcs) {
                await that._promiseCallInClass(f, owner, shared);
            }
            return shared;
        }
        return call();
    }

    terminal() {
        this?.lastReject("terminal");
        this.lastReject = null;
    }
}

setTimeout(() => {
    async.terminal();
}, 4000)

```

- 分析：
1. 若terminal在call3之前 则call3不会调用
```
call2
terminal call
reject terminal
call2 call { a: 11, b: 22 }
```
2. 若call3已经调用 但还在定时器过程中 并没有结束；则termial调用后;这块需要优化！！！
```
call3
reject terminal
call3 call { a: 11, b: 22, c: 33 }
```
3. 若termial在所有call调用之后，则没任何反应；即：promise已经结束了，内部的reject还能被调用，但没啥反应
```
call3 call { a: 11, b: 22, c: 33 }
success { a: 11, b: 22, c: 33 }
terminal call
```















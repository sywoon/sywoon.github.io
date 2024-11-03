
# es5 和 es6区别
- 变量声明
ES5：使用 var 声明变量，存在变量提升（hoisting）和全局作用域的问题。
ES6：引入 let 和 const，支持块级作用域，避免了变量提升的问题。

- 模块化
ES5：没有原生模块化支持，通常使用 IIFE（立即调用函数表达式）或其他库（如 CommonJS）。
ES6：原生支持模块化，使用 import 和 export 。

- 字符串
es6引入模板字符串

- 对象和数组操作
es6引入解构赋值和扩展运算符，简化了对象和数组的操作。

- 类和继承
ES5：使用构造函数和原型链实现面向对象编程。
ES6：引入 class 关键字，支持更简洁的类定义和继承。

- 异步编程
es6引入promise



# ES5 ECMAScript 5

## ES5的主要特性
1. use strict 
2. Array.isArray forEach map filter reduce every some indexOf lastIndexOf
3. JSON.parse stringify()
4. Object.defineProperty defineProperties getOwnPropertyDescriptor getOwnPropertyNames keys 
   getPrototypeOf preventExtensions isExtensible seal isSealed freeze isFrozen
5. 对象定义属性 getter setter 注意：还不是类  只是object {}


# ES6 - ECMAScript2015
也就是ECMAScript2015是在2015年6月  
对 JavaScript 进行了深刻的扩展和升级，ES6 是 JavaScript 语言的一个里程碑

## ECMAScript2015 新增特性
1. let const  块级作用域 
2. 箭头函数 ()=> {}
3. 模板字符串  `hell_${a}`
4. 函数默认参数 (name="a")=>
5. 解构赋值 const [a,b] = [1,2]
6. 类和继承 class B extends A
7. 模块化 import export
8. Promise  
9. 扩展运算符  arr = [...arr1, 2, 3]  obj = {...obj1, b:2}
10. Symbol  唯一命名 ？  s = Symbol("obj1")
```
let p = new Promise((resolve, reject)=>{
    if (true) resolve('xx')
    else reject('xx')
})
p.then(result=>console.log(result)).catch(err=>console.error(err))
```
1. for ... of;  for ... in
2.  Set-唯一值  Map


## ECMAScript2016 
1. 指数操作符 2 ** 3
2. Array.prototype.includes(e)  判断是否存在


## ECMAScript2017 - ES8
1. 异步函数 async wait - 等待一个promise
2. Object.values() .entries()-键值对数组
3. 字符串填充 str.padStart(num, '*')  .padEnd
4. 共享内存与原子操作 SharedArrayBuffer Atomics ？


## ECMAScript2019
ECMAScript 2018 并入了 ECMAScript 2019
1. Array.prototype.flat()  .flatMap()  扁平化嵌套的数组结构
2. Object.fromEntries() 键值对转map对象
3. String.prototype.trimStart() trimEnd()
4. Symbol.prototype.description()  ?
5. Function.prototype.toString()


## ECMAScript2020 - ES11
1. 可选链操作符Optional Chainning  ?. 减少冗长的判断
2. 空值合并操作符 r = v ?? default;  判断v是否为null和undefined
3. 全局对象globalThis 支持浏览器 nodejs webworkers；  ===window || global
4. Promise.allSettled([p1,p2]).then  等待所有promise执行完毕
5. 动态导入  ？
6. BigInt  ？
7. matchAll  string的用法？


## ECMAScript2021
1. 字符串全局替换  s.replaceAll('apple', 'grape');
2. 逻辑赋值运算符  &&= ||= ??=
3. 数字分隔符： 允许数字可用下划线  v = 1_000_000  有点鸡肋
4. Promise.any  返回第一个promise的值
5. WeakRef  FinalizationRegistry  ？

## ECMAScript2022
1. 顶层await 无需嵌套入async


## ECMAScript2023
1. Array.findLast findLastIndex
2. HashBang语法 #!/usr/bin/env node  指定执行的解释器
3. Array.toReversed() .toSorted() .tospliced() with() 不改变原数组






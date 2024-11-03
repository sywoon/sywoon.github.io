

## 各种打包工具比较
- webpack
模块化打包工具 支持es6 commonjs 插件系统
优：代码切割 懒加载；处理非js资源
劣：配置复杂 学习陡峭

- gulp
流式构建工具 基于代码来构建和管理任务 有大量插件
优：简单任务 小项目 
劣：复杂模块打包和依赖支持度不够


- rollup
es6模块打包 适合库打包
优：生成的代码干净、高效；支持tree-shaking去除废代码；分割代码
劣：对commonjs和其他模块方式支持不好

- parcel
0配置打包工具
优：简单易用
劣：灵活性和功能不够

- browserify
将nodejs风格的模块代码 打包为浏览器可用的代码
优：对commonjs支持好；浏览器中是哟给你nodejs的模块变得简单
劣：功能简单

结论：
1. 大的项目：webpack 除了打包 还能支持资源文件处理
2. 多任务管理：gulp 不专注于打包
3. 编译库：rollup
4. 快速开发 demo调试：parcel 无需配置
5. 浏览器使用nodejs库：browserify






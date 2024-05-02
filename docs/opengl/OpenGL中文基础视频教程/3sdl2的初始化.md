# 🔙[OpenGL](/docs/opengl/)



## sdl2的初始化
```
	SDL_Init(SDL_INIT_EVERYTHING);

	SDL_GL_SetAttribute(SDL_GL_RED_SIZE, 8);
	SDL_GL_SetAttribute(SDL_GL_GREEN_SIZE, 8);
	SDL_GL_SetAttribute(SDL_GL_BLUE_SIZE, 8);
	SDL_GL_SetAttribute(SDL_GL_ALPHA_SIZE, 8);
	SDL_GL_SetAttribute(SDL_GL_BUFFER_SIZE, 32);
	SDL_GL_SetAttribute(SDL_GL_DOUBLEBUFFER, 1);

	_window = SDL_CreateWindow(title.c_str(), 
					SDL_WINDOWPOS_CENTERED,
					SDL_WINDOWPOS_CENTERED,
					width, height, SDL_WINDOW_OPENGL);

	_glContext = SDL_GL_CreateContext(_window);
```

## glew的初始化
```
	GLenum status = glewInit();
	if (status != GLEW_OK)
	{
		std::cerr << "glew init failure" << std::endl;
	}
```

## sdl的释放
```
	SDL_GL_DeleteContext(_glContext);
	SDL_DestroyWindow(_window);
	SDL_Quit();
```

## sdl的更新：缓冲区 + event
```
	SDL_GL_SwapWindow(_window);
	SDL_Event event;
	while (SDL_PollEvent(&event))
	{
		if (event.type == SDL_QUIT)
		{
			_isClosed = true;
		}
	}
```
- 若把sdl相关功能封装到Display对象后  
Main中的使用方式：  
```
	while (!display.IsClosed())
    {
        display.Clear(0.0f, 0.15f, 0.3f, 1.0f);
        ...
        display.Update();
     }
     
  主循环中不断调用sdl的更新
  关闭窗口会触发close标识 从而退出main函数
```





---
title: Spring MVC DispatcherServlet请求流程
date: 2020-04-22 21:55:07
tags: spring mvc
categories: spring mvc
---



```java
private List<HandlerMapping> handlerMappings;

private List<HandlerAdapter> handlerAdapters;

private List<ViewResolver> viewResolvers;
```



1.找到当前请求的HandlerExecutionChain

```java
protected HandlerExecutionChain getHandler(HttpServletRequest request) throws Exception {
	if (this.handlerMappings != null) {
		for (HandlerMapping mapping : this.handlerMappings) {
			HandlerExecutionChain handler = mapping.getHandler(request);
			if (handler != null) {
				return handler;
			}
		}
	}
	return null;
}
```

2.寻找当前处理器对象对应的处理器适配器

```java
// 遍历DispatcherServlet中的handlerAdapters，寻找当前请求对应的处理器适配器
protected HandlerAdapter getHandlerAdapter(Object handler) throws ServletException {
	if (this.handlerAdapters != null) {
		for (HandlerAdapter adapter : this.handlerAdapters) {
			if (adapter.supports(handler)) {
				return adapter;
			}
		}
	}
	throw new ServletException("No adapter for handler [" + handler +
			"]: The DispatcherServlet configuration needs to include a HandlerAdapter that supports this handler");
}
```

3.根据ModelAndView中的视图名，寻找对应的视图解析器，对视图名进行解析，返回View对象。

```java
protected View resolveViewName(String viewName, @Nullable Map<String, Object> model,
		Locale locale, HttpServletRequest request) throws Exception {

	if (this.viewResolvers != null) {
		for (ViewResolver viewResolver : this.viewResolvers) {
			View view = viewResolver.resolveViewName(viewName, locale);
			if (view != null) {
				return view;
			}
		}
	}
	return null;
}
```


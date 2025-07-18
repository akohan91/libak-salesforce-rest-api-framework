/**
 * The `libak_RestRouter` class is responsible for routing incoming REST requests to the appropriate `libak_RestProcessor` based
 * on the requested URI. It maintains a mapping of routes to `libak_RestProcessor` types and dynamically creates instances
 * of the appropriate processor.
 */
public abstract class libak_RestRouter {
	protected Map<String, Type> routeToRestProcessorType;
	protected Map<String, Type> routeToErrorResponseFactoryType;
	protected Map<String, Type> routeToLoggerType;

	/**
	 * Sets the routes for the `libak_RestRouter`.
	 * Implement this method to define the routing logic.
	 * Implement to set the value for the `routeToRestProcessorType` property as <route>:<libak_RestProcessor type>
	 *
	 * @return The current `libak_RestRouter` instance.
	 */
	abstract public libak_RestRouter setRoutes();
	
	/**
	 * Sets the route-specific error response factory types for the `libak_RestRouter`.
	 * Override this method to define custom error response factories for specific routes.
	 * Implementation should set values for the `routeToErrorResponseFactoryType` property 
	 * as <route>:<libak_IErrorResponseFactory type> mappings.
	 *
	 * @return The current `libak_RestRouter` instance for method chaining.
	 */
	virtual public libak_RestRouter setRouteToErrorResponseFactoryType() {
		return this;
	}

	/**
	 * Sets the route-specific logger types for the `libak_RestRouter`.
	 * Override this method to define custom loggers for specific routes.
	 * Implementation should set values for the `routeToLoggerType` property 
	 * as <route>:<libak_IRestLogger type> mappings.
	 *
	 * @return The current `libak_RestRouter` instance for method chaining.
	 */
	virtual public libak_RestRouter setRouteToLoggerType() {
		return this;
	}

	/**
	 * Creates a new `libak_RestProcessor` instance for handling the incoming REST request with a custom error response factory
	 * and REST logger. This method dynamically selects the appropriate `libak_RestProcessor` based on the requested URI.
	 *
	 * @param request              The `RestRequest` object representing the incoming HTTP request.
	 * @param errorResponseFactory The custom error response factory to use for generating error responses.
	 * @param restLogger           The custom REST logger to use for logging REST-related information.
	 * @return A new `libak_RestProcessor` instance configured to handle the specified REST request with custom error handling and logging.
	 * @throws libak_RestFramework.InvalidUriException If the requested URI does not match any defined routes.
	 */
	public libak_RestProcessor newRestProcessor(RestRequest request, libak_IErrorResponseFactory errorResponseFactory, libak_IRestLogger restLogger) {
		List<String> sortedRoutes = new List<String>(this.routeToRestProcessorType.keySet());
		sortedRoutes.sort();
		while (sortedRoutes.size() > 0) {
			String route = sortedRoutes.remove(0);
			if (this.isRouteExists(route, request.requestURI)) {
				libak_RestProcessor restProcessorItem = (libak_RestProcessor)routeToRestProcessorType.get(route).newInstance();
				return restProcessorItem
					.useRestRequest(request)
					.useErrorResponseFactory(
						this.routeToErrorResponseFactoryType?.get(route) == null
						? errorResponseFactory
						: (libak_IErrorResponseFactory)this.routeToErrorResponseFactoryType.get(route).newInstance()
					)
					.useRestLogger(
						this.routeToLoggerType?.get(route) == null
						? restLogger
						: (libak_IRestLogger)this.routeToLoggerType.get(route).newInstance()
						
					)
					.useUriTemplate(route);
			}
		}
		throw new libak_RestFramework.InvalidUriException(libak_RestFramework.ERROR_MESSAGE_INVALID_URI + request.requestURI);
	}

	/**
	 * Checks if a route exists based on the requested URI.
	 *
	 * @param route      The route pattern to check.
	 * @param requestURI The requested URI.
	 * @return `true` if the route exists for the given URI, `false` otherwise.
	 */
	private Boolean isRouteExists(String route, String requestURI) {
		String routeTemplateRegEx = route
			.replaceAll('\\*', '\\.+')
			.replaceAll('\\{(.+?)/', '\\.+/')
			.replaceAll('\\{(.+?)$', '\\.+');
		return Pattern.matches('(?i)' + routeTemplateRegEx, requestURI.replaceAll('(\\/+)$', ''));
	}
}
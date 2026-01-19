/**
 * The `libak_RestFramework` class provides a structured framework for building RESTful web services in Salesforce Apex.
 * It includes interfaces for routing, response handling, error management, and logging, along with core components
 * for processing RESTful requests.
 */
public class libak_RestFramework {
	/**
	 * Handles an incoming REST request using the specified router.
	 *
	 * @param routerType The type of the router to use for routing the request.
	 */
	public static void handleRequest(Type routerType) {
		handleRequest(routerType, null);
	}

	/**
	 * Handles an incoming REST request using the specified router and error response factory.
	 *
	 * @param routerType            The type of the router to use for routing the request.
	 * @param loggerType The type of the logger to use for logging REST-related information (optional, can be null).
	 */
	public static void handleRequest(Type routerType, Type loggerType) {
		handleRequest(routerType, loggerType, libak_ErrorResponseFactory.class);
	}

	/**
	 * Handles an incoming REST request using the specified router, logger, and error response factory.
	 *
	 * @param routerType The type of the router to use for routing the request.
	 * @param loggerType The type of the logger to use for logging REST-related information (optional, can be null).
	 * @param errorResponseFactoryType The type of the error response factory to use for creating error responses (optional, can be null).
	 */
	public static void handleRequest(Type routerType, Type loggerType, Type errorResponseFactoryType) {
		libak_IRestResponse response;
		libak_IErrorResponseFactory errorResponseFactory;
		libak_IRestLogger restLogger;
		try {
			errorResponseFactory = (libak_IErrorResponseFactory)errorResponseFactoryType?.newInstance();
			restLogger = (libak_IRestLogger)loggerType?.newInstance();
			restLogger?.initLog(RestContext.request);
			libak_RestRouter router = ((libak_RestRouter)routerType.newInstance())
				.setRoutes()
				.setRouteToErrorResponseFactoryType()
				.setRouteToLoggerType();
			libak_RestProcessor processor = router
				.newRestProcessor(RestContext.request, errorResponseFactory, restLogger);
			response = processor.process();
		} catch (Exception exc) {
			response = errorResponseFactory.newErrorRestResponse(exc);
			restLogger?.addErrorDetails(exc);
		} finally {
			response.sendResponse();
			restLogger?.createLog();
		}
	}

	/**
	 * This exception is thrown when an invalid URI is encountered. It represents a client error (HTTP 400 Bad Request).
	 */
	public class InvalidUriException extends Exception {}

	/**
	 * This exception is thrown when an HTTP method is not allowed for a particular resource. It represents a client error (HTTP 405 Method Not Allowed).
	 */
	public class MethodNotAllowedException extends Exception {}
}
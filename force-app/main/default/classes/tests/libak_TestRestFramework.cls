@IsTest
public with sharing class libak_TestRestFramework {

	public static final String URI_TEMPLATE_WITH_PARAMS = '/testRestFramework/{uriParam}';
	public static final String URI_TEMPLATE_WITHOUT_PARAMS = '/testRestFramework';

	@IsTest
	static void testHandleRequestPositive(){
		RestRequest request = new RestRequest();
		request.requestURI = '/testRestFramework/param_1';
		RestContext.request = request;
		RestContext.response = new RestResponse();

		Test.startTest();

		libak_RestFramework.handleRequest(RestRouterInstance.class);

		Test.stopTest();

		System.assertEquals(
			libak_RestConstants.HTTP_CODE_METHOD_NOT_ALLOWED,
			RestContext.response.statusCode,
			'The status code of response should be 405'
		);
	}

	@IsTest
	static void testHandleRequestWithoutParamsPositive(){
		RestRequest request = new RestRequest();
		request.requestURI = '/testRestFramework';
		RestContext.request = request;
		RestContext.response = new RestResponse();

		Test.startTest();

		libak_RestFramework.handleRequest(RestRouterInstance.class);

		Test.stopTest();

		System.assertEquals(
			libak_RestConstants.HTTP_CODE_METHOD_NOT_ALLOWED,
			RestContext.response.statusCode,
			'The status code of response should be 405'
		);
	}

	@IsTest
	static void testHandleRequestWithoutParamsWithSlashAtTheEnd(){
		RestRequest request = new RestRequest();
		request.requestURI = '/testRestFramework/';
		RestContext.request = request;
		RestContext.response = new RestResponse();

		Test.startTest();

		libak_RestFramework.handleRequest(RestRouterInstance.class);

		Test.stopTest();

		System.assertEquals(
			libak_RestConstants.HTTP_CODE_METHOD_NOT_ALLOWED,
			RestContext.response.statusCode,
			'The status code of response should be 405'
		);
	}

	@IsTest
	static void testHandleRequestWrongRouter(){
		RestRequest request = new RestRequest();
		request.requestURI = '/testRestFramework/param_1';
		RestContext.request = request;
		RestContext.response = new RestResponse();

		Test.startTest();

		libak_RestFramework.handleRequest(String.class);

		Test.stopTest();

		System.assertEquals(
			libak_RestConstants.HTTP_CODE_INTERNAL_SERVER_ERROR,
			RestContext.response.statusCode,
			'The status code of response should be 500'
		);

		libak_ErrorResponse errorResponse = (libak_ErrorResponse)JSON.deserialize(
			RestContext.response.responseBody.toString(),
			libak_ErrorResponse.class
		);
		System.assertEquals(
			libak_RestConstants.ERROR_MESSAGE_INTERNAL_SERVER_ERROR,
			errorResponse.summary,
			'The summary property of response is wrong.'
		);
	}

	private class RestRouterInstance extends libak_RestRouter {
		override public libak_RestRouter setRoutes() {
			this.routeToRestProcessorType = new Map<String, Type>{
				URI_TEMPLATE_WITH_PARAMS => libak_RestProcessor.class,
				URI_TEMPLATE_WITHOUT_PARAMS => libak_RestProcessor.class
			};
			return this;
		}
	}
}
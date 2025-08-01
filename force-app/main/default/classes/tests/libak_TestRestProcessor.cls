@IsTest
public with sharing class libak_TestRestProcessor {
	// Assertions are performed in the checkMethodNotAllowedResponse helper method
	@SuppressWarnings('PMD.ApexUnitTestClassShouldHaveAsserts')
	@IsTest
	static void testProcessGet(){
		checkMethodNotAllowedResponse('GET');
	}

	// Assertions are performed in the checkMethodNotAllowedResponse helper method
	@SuppressWarnings('PMD.ApexUnitTestClassShouldHaveAsserts')
	@IsTest
	static void testProcessPost(){
		checkMethodNotAllowedResponse('POST');
	}

	// Assertions are performed in the checkMethodNotAllowedResponse helper method
	@SuppressWarnings('PMD.ApexUnitTestClassShouldHaveAsserts')
	@IsTest
	static void testProcessPut(){
		checkMethodNotAllowedResponse('PUT');
	}

	// Assertions are performed in the checkMethodNotAllowedResponse helper method
	@SuppressWarnings('PMD.ApexUnitTestClassShouldHaveAsserts')
	@IsTest
	static void testProcessPatch(){
		checkMethodNotAllowedResponse('PATCH');
	}

	// Assertions are performed in the checkMethodNotAllowedResponse helper method
	@SuppressWarnings('PMD.ApexUnitTestClassShouldHaveAsserts')
	@IsTest
	static void testProcessDelete(){
		checkMethodNotAllowedResponse('DELETE');
	}

	// Assertions are performed in the checkMethodNotAllowedResponse helper method
	@SuppressWarnings('PMD.ApexUnitTestClassShouldHaveAsserts')
	@IsTest
	static void testProcessOther(){
		checkMethodNotAllowedResponse('OPTIONS');
	}

	@IsTest
	static void testGetUriParam(){
		String paramValue = 'param_1';
		RestRequest request = new RestRequest();
		request.requestURI = '/testRestRouter/' + paramValue;
		libak_RestProcessor processor = prepareDefaultRestProcessor(request);

		Test.startTest();

		String uriParam = processor.getUriParam('uriParam');

		Test.stopTest();

		System.assertEquals(1, processor.uriParamsMap.size(), 'The "uriParamsMap" property is wrong.');
		System.assertEquals(paramValue, uriParam, 'The uri param is wrong.');
	}

	@IsTest
	static void testGetQueryParam(){
		String paramName = 'query_param';
		String paramValue = 'param_1';
		RestRequest request = new RestRequest();
		request.requestURI = '/testRestRouter/uri_param';
		request.addParameter(paramName, paramValue);
		libak_RestProcessor processor = prepareDefaultRestProcessor(request);

		Test.startTest();

		String queryParam = processor.getQueryParam(paramName);

		Test.stopTest();

		System.assertEquals(paramValue, queryParam, 'The query param is wrong.');
	}

	@IsTest
	static void testGetHeader(){
		RestRequest request = new RestRequest();
		request.requestURI = '/testRestRouter/uri_param';
		request.addHeader(libak_RestFramework.HEADER_NAME_CONTENT_TYPE, libak_RestFramework.CONTENT_TYPE_APPLICATION_JSON);
		libak_RestProcessor processor = prepareDefaultRestProcessor(request);

		Test.startTest();

		String header = processor.getHeader(libak_RestFramework.HEADER_NAME_CONTENT_TYPE);

		Test.stopTest();

		System.assertEquals(libak_RestFramework.CONTENT_TYPE_APPLICATION_JSON, header, 'The header is wrong.');
	}

	private static libak_RestProcessor prepareDefaultRestProcessor(RestRequest request) {
		return new libak_RestProcessor()
			.useRestRequest(request)
			.useUriTemplate('/testRestRouter/{uriParam}')
			.useRestLogger(null)
			.useErrorResponseFactory(new libak_ErrorResponseFactory());
	}

	private static void checkMethodNotAllowedResponse(String httpMethod) {
		RestContext.request = new RestRequest();
		RestContext.request.httpMethod = httpMethod;
		RestContext.response = new RestResponse();

		libak_RestProcessor processor = prepareDefaultRestProcessor(RestContext.request);

		Test.startTest();

		libak_IRestResponse response = processor.process();
		response.sendResponse();

		Test.stopTest();

		System.assert(
			RestContext.response.headers.containsKey(libak_RestFramework.HEADER_NAME_CONTENT_TYPE),
			'The response should have the "Content-Type" header.'
		);
		System.assertEquals(
			libak_RestFramework.CONTENT_TYPE_APPLICATION_JSON,
			RestContext.response.headers.get(libak_RestFramework.HEADER_NAME_CONTENT_TYPE),
			'The "Content-Type" header should be "application/json"'
		);
		System.assertEquals(
			libak_RestFramework.HTTP_CODE_METHOD_NOT_ALLOWED,
			RestContext.response.statusCode,
			'The status code of response should be 405'
		);
		System.assertEquals(
			Blob.valueOf(JSON.serialize(response)),
			RestContext.response.responseBody,
			'The response data is wrong'
		);
	}
}
@IsTest
public with sharing class libak_TestErrorResponse {

	@IsTest
	static void testErrorResponseInstance(){
		RestContext.response = new RestResponse();
		libak_IRestResponse response = new libak_ErrorResponse(
			libak_RestConstants.HTTP_CODE_BAD_REQUEST,
			new libak_RestFramework.InvalidUriException('Bad Request')
		);

		Test.startTest();

		response.sendResponse();

		Test.stopTest();

		System.assert(
			RestContext.response.headers.containsKey(libak_RestConstants.HEADER_NAME_CONTENT_TYPE),
			'The response should have the "Content-Type" header.'
		);
		System.assertEquals(
			libak_RestConstants.CONTENT_TYPE_APPLICATION_JSON,
			RestContext.response.headers.get(libak_RestConstants.HEADER_NAME_CONTENT_TYPE),
			'The "Content-Type" header should be "application/json"'
		);
		System.assertEquals(
			libak_RestConstants.HTTP_CODE_BAD_REQUEST,
			RestContext.response.statusCode,
			'The status code of response should be ' + libak_RestConstants.HTTP_CODE_BAD_REQUEST
		);
		System.assertEquals(
			Blob.valueOf(JSON.serialize(response)),
			RestContext.response.responseBody,
			'The response data is wrong'
		);
	}

}
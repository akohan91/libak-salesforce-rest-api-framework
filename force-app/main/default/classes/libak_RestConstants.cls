/**
 * The `libak_RestConstants` class contains all constant values used throughout the REST framework.
 * This includes HTTP status codes, header names, content types, and error messages.
 */
public class libak_RestConstants {
	// Constants for HTTP status codes
	public static final Integer HTTP_CODE_OK = 200;
	public static final Integer HTTP_CODE_BAD_REQUEST = 400;
	public static final Integer HTTP_CODE_NOT_FOUND = 404;
	public static final Integer HTTP_CODE_METHOD_NOT_ALLOWED = 405;
	public static final Integer HTTP_CODE_INTERNAL_SERVER_ERROR = 500;

	// Constants for HTTP headers
	public static final String HEADER_NAME_CONTENT_TYPE = 'Content-Type';

	// Constants for content types
	public static final String CONTENT_TYPE_APPLICATION_JSON = 'application/json';
	public static final String CONTENT_TYPE_APPLICATION_PDF = 'application/pdf';

	// Constants for error messages
	public static final String ERROR_MESSAGE_INTERNAL_SERVER_ERROR = 'Internal Server Error';
	public static final String ERROR_MESSAGE_INVALID_URI = 'Invalid URI: ';
	public static final String ERROR_MESSAGE_METHOD_NOT_ALLOWED = 'The {0} http method is not available for this resource: {1}.';
}

/**
 * The `libak_IErrorResponseFactory` interface defines a method for creating error responses.
 */
public interface libak_IErrorResponseFactory {
	libak_IRestResponse newErrorRestResponse(Exception exc);
}
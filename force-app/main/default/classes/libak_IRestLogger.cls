/**
 * The `libak_IRestLogger` interface defines methods for logging REST-related information.
 */
public interface libak_IRestLogger {
	void initLog(RestRequest request);
	void addErrorDetails(Exception exc);
	void createLog();
}


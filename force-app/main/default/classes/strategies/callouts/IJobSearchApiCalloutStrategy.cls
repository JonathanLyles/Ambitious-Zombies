/**
 * IJobSearchApiCalloutStrategy defines the contract for API callout strategies.
 * Implementations of this interface encapsulate the logic required to perform
 * HTTP callouts to external job listing APIs. This allows the service layer
 * to invoke different API strategies interchangeably without knowing the
 * details of the HTTP requests.
 *  
 * Usage Example:
 * 
 * IJobSearchApiCalloutStrategy strategy = new SomeJobApiStrategy();
 * Map<String, Object> params = new HashMap<>();
 * params.put("keywords", "Salesforce");
 * params.put("location", "Montreal");
 * HttpResponse response = strategy.execute(params);
 * }
 *
 * @author Jonathan Lyles
 * @since 2025-10-08
 */
public interface IJobSearchApiCalloutStrategy {
    HttpResponse execute(Map<String, String> params);
}
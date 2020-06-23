/**
 * Name: UTrust Webhook model
 * Author: Gary Stanton (gary@simianenterprises.co.uk)
 * Description: Wrapper for the UTrust Stores API.
 * This model handles a request sent to your webhook URL
 */
component accessors="true" {

    property name="webhookSecret" type="string";
    property name="payload" type="struct";

    /**
     * Constructor
     * @webhookSecret Your webhook secret. Get one at https://merchants.sandbox-utrust.com/onboarding/get-started
     * @payload The payload sent by the Utrust server
     */
    public webhook function init(
            required string WebhookSecret
        ,   required string Payload
    ){
        setWebhookSecret(Arguments.WebhookSecret);

        // Make sure it's a valid JSON
        if (!isJSON(Arguments.Payload)) {
            throw('Invalid payload provided. No JSON object could be decoded.', 'Utrust Webhook');
        }
        else {
            setPayload(deserializeJSON(Arguments.Payload));
        }

        // Make sure it has an event type
        if (!StructKeyExists(getPayload(), 'event_type')) {
            throw('Event type is missing on the payload.', 'Utrust Webhook');
        }

        // Make sure it has a reference
        if (!StructKeyExists(getPayload(), 'resource') && StructKeyExists(getPayload(), 'reference')) {
            throw('Reference is missing on the payload.', 'Utrust Webhook');
        }

        return this;
    }


    /**
     * Get Event Type data
     *
     * @return string Event Type data.
     */
    public function getEventType() {
        return getPayload().event_type;
    }

    /**
     * Get Order Reference data
     *
     * @return string Order Reference data.
     */
    public function getOrderReference() {
        return getPayload().resource.reference;
    }

    /**
     * Get Order State
     *
     * @return string Order State.
     */
    public function getState() {
        return getPayload().state;
    }

    /**
     * Get Amount
     *
     * @return string Amount.
     */
    public function getAmount() {
        return getPayload().resource.amount;
    }

    /**
     * Get Currency
     *
     * @return string Currency.
     */
    public function getCurrency() {
        return getPayload().resource.currency;
    }

    /**
     * Get Signature data
     *
     * @return string Signature data.
     */
    public function getSignature() {
        return getPayload().signature;
    }

    /**
     * Verify the incoming webhook notification to make sure it is legit.
     *
     * @return bool
     * @throws Exception
     */
    public function validateSignature(){
        var payload = StructCopy(getPayload());

        // Remove signature from response
        structDelete(payload, 'signature');

        // Concat keys and values into one string
        var concatedPayload = [];
        for (Local.thiskey in payload) {
            if (isStruct(payload[Local.thisKey])) {
                for (Local.subKey in payload[Local.thisKey]) {
                    concatedPayload.append(Local.thisKey & Local.subKey & payload[Local.thisKey][Local.subKey]);
                }
            }
            else {
                concatedPayload.append(Local.thisKey & payload[Local.thisKey]);
            }
        }

        // Sort array alphabetically and convert to string
        concatedPayload.sort('textnocase', 'asc');
        // Convert to string
        concatedPayload = concatedPayload.toList('');
        // Sign the string
        var signedPayload = lcase(hmac(concatedPayload, getWebhookSecret(), "HMACSHA256"));
        // Compare string
        if (signedPayload == getSignature()) {
            return true;
        }
        else {
            throw('Invalid signature!', 'Utrust Webhook');
        }
    }
}
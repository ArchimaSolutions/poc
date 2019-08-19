public with sharing class SymphonyDecodeRatingEvent {
    public SymphonyDecodeRatingEvent() {

    }

    @InvocableMethod(label='Decode Rating')
    public static List<String> decodeRating(List<String> b64) {
        List<String> theReturn = new List<String>();
        theReturn.add(EncodingUtil.base64Decode(b64[0]).toString());
        return theReturn;
    }
}

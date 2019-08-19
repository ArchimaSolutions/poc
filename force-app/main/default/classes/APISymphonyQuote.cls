/*
 * Symphony Quote API
 * 
 * POST /quote/
 * PUT /quote/
 * GET /quote/{id}
 * GET /quote?status={status}
 * 
 */
@RestResource(urlMapping='/symphony/quote/*')
global with sharing class APISymphonyQuote {

    @HttpPost
    global static SymphonyQuote createQuote(SymphonyQuote symphonyQuote) {
        System.debug('CREATE\n\n' + JSON.serialize(symphonyQuote));

        Quote quote = symphonyQuote.toQuote();
        insert quote;

        return new SymphonyQuote(quote);
    }

    @HttpPut
    global static SymphonyQuote updateGroup(SymphonyQuote symphonyQuote) {
        System.debug('UPDATE\n\n' + JSON.serialize(symphonyQuote));

        Quote quote = symphonyQuote.toQuote();
        update quote;

        return new SymphonyQuote(quote);
    }
    
    @HttpGet
    global static List<SymphonyQuote> getQuotes() {
        String id = RestContext.request.params.get('id');
        String status = RestContext.request.params.get('status');

        List<SymphonyQuote> symphonyQuotes;

        if (String.isNotBlank(id)) {
            List<Quote> quotes = [
                SELECT
                	Id
                FROM
                	Quote
                WHERE
                	Id = :id
            ];
            
            if (quotes.size() > 0) {
                SymphonyQuote symphonyQuote = new SymphonyQuote(quotes[0]);
                symphonyQuotes = new List<SymphonyQuote>{symphonyQuote};
            } else {
                // No record found.
        		RestContext.response.statusCode = 404;
            }
        } else if (String.isNotBlank(status)) {
            List<Quote> quotes = [
                SELECT
                	Id
                FROM
                	Quote
                WHERE
                	Status = :status
            ];
            
            symphonyQuotes = new List<SymphonyQuote>();

            for (Quote quote : quotes) {
                symphonyQuotes.add(new SymphonyQuote(quote));
            }
        } else {
        	// Invalid request.
        	RestContext.response.statusCode = 400;    
        }

        return symphonyQuotes;
    }


    global class SymphonyQuote {

		global String id {get; set;}


        global SymphonyQuote() {
        }

        global SymphonyQuote(Quote quote) {
            id = quote.Id;
        }

        public Quote toQuote() {
            Quote quote = new Quote();
            quote.Id = id;
            return quote;
        }

    }
    
}
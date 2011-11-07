/*
Organisaties en contacten

Onder elk contact kunnen dezelfde properties ingevuld worden als bij een organisatie.
"contacts" moet wel bestaan. Het kan niet leeg zijn.

Template:
organisations = {
    "<Naam organisatie 1>": {
        "address": "<adres>",
        "city": "<stad>",
        "state": "<provincie>",
        "postalCode": "<postcode>",
        "country": "<land>",
        "url": "<url>",
        "email": "<email adres>",
        "voice": "<telefoonnummer>",
        "contacts": {
            "<contact naam 1>": {
                "email": "chrisvanlith@b3partners.nl"
            },
            "<contact naam 2>": {
                "email": "erikvandepol@b3partners.nl"
            }
        }
    },
    "<Naam organisatie 2>": {
        "address": "<adres>",
        "city": "<stad>",
        "state": "<provincie>",
        "postalCode": "<postcode>",
        "country": "<land>",
        "url": "<url>",
        "email": "<email adres>",
        "voice": "<telefoonnummer>",
    }
};

etc...
*/

organisations = {
    "Waterschap Rivierenland": {
        "address": "Blomboogerd 1",
        "city": "Tiel",
        "state": "Gelderland",
        "postalCode": "4003 BX",
        "country": "Nederland",
        "url": "http://www.wsrl.nl",
        "email": "info@wsrl.nl",
        "voice": "0344 64 90 90",
        "contacts": {}
    }
};
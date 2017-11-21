<%-- 
    Document   : organisations
    Created on : 9-aug-2011, 14:23:29
    Author     : Erik van de Pol
--%>

<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<div style="padding: 1em">
    <p>
        Bewerk de toegestane organisaties en contactpersonen. 
        Onthoud dat er altijd een correcte JSON datastructuur uit moet komen. 
        Als dit niet het geval is, kan het zo zijn dat de hele site niet meer werkt. 
        Onder elk contact kunnen dezelfde properties ingevuld worden als bij een organisatie.
        Toevoegen gaat sneller door in de editor een nieuwe organisatienaam met bijbehorende info
        in te vullen. Na opslaan wordt deze aan de lijst toegevoegd. Verwijderen moet hier
        gebeuren.</p>
    <textarea id="organisationsJSON"><c:out value="${actionBean.organisations}"/></textarea>

<pre>
Voorbeeld:  
{  
    "B3Partners": {  
        "address": "???",  
        "city": "???",  
        "state": "???",  
        "postalCode": "???",  
        "country": "???",  
        "url": "???",  
        "email": "???",  
        "voice": "???",  
        "contacts": {  
            "contact naam 1": {  
                "email": "???"  
            },  
            "contact naam 2": {  
                "email": "???"  
            }  
        }  
    },  
    "Klant 1": {  
        "address": "???",  
        "city": "???",  
        "state": "???",  
        "postalCode": "???",  
        "country": "???",  
        "url": "???",  
        "email": "???",  
        "voice": "???" 
    }
}
</div>

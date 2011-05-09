<%-- 
    Document   : loginForm
    Created on : 14-jan-2011, 11:34:48
    Author     : Erik van de Pol
--%>
<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>


<stripes:layout-definition>

    <script type="text/javascript">
        /*console.log("hash 1: " + window.location.hash);
        window.location.hash = window.location.hash;
        console.log("hash 2: " + window.location.hash);*/
        $(document).ready(function() {
            $("#gebruikersnaam").focus().select();
            $("#login-form").submit(function() {
                $.cookie("mdeLoginHash", location.hash);
            });
        });
    </script>

    <h2>Inloggen bij ${title}</h2>
    <p>U dient in te loggen bij ${title} met uw gewone ${customer} gebruikersnaam en wachtwoord. Dit is nodig om te bepalen of u enkel commentaar kunt leveren op metadata of dat u metadata ook kan aanpassen en aanmaken.</p>

    <form id="login-form" method="post" action="j_security_check" class="form_ll">

        <p class="mandatory">Verplichte velden zijn gemarkeerd met een <em title="verplicht veld">*</em></p>

        <fieldset>
            <legend>Login</legend>
            <ol>
                <li>
                    <label for="gebruikersnaam">Gebruikersnaam <span title="verplicht veld">*</span></label>
                    <input type="text" class="text" name="j_username" id="gebruikersnaam" />
                </li>
                <li>
                    <label for="wachtwoord">Wachtwoord <span title="verplicht veld">*</span></label>
                    <input type="password" class="text" name="j_password" id="wachtwoord" />
                    <!--input type="password" class="text err" name="j_password" id="wachtwoord" />
                    <p class="password"><a href="#" title="Wachtwoord vergeten?">Wachtwoord vergeten?</a></p-->
                </li>
            </ol>
        </fieldset>

        <p><input type="submit" name="submit" value="Login" class="submit" /></p>

    </form>

</stripes:layout-definition>
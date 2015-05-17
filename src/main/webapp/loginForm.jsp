<%-- 
    Document   : loginForm
    Created on : 14-jan-2011, 11:34:48
    Author     : Erik van de Pol
--%>
<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>


<stripes:layout-definition>

    <script type="text/javascript">
        $(document).ready(function() {
            $("#gebruikersnaam").focus().select();
            $("#login-form").submit(function() {
                // In IE is location.hash leeg. (Workaround: na inloggen nogmaals url pasten in address bar.)
                $.cookie("mdeLoginHash", location.hash);
            });
        });
    </script>

    <h2>Inloggen bij ${title}</h2>
    <p>U dient in te loggen bij ${title}. Dit is nodig om te bepalen of u enkel commentaar kunt leveren op metadata of dat u metadata ook kan aanpassen en aanmaken.</p>

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
                </li>
            </ol>
        </fieldset>

        <p><input type="submit" name="submit" value="Login" class="submit" /></p>

    </form>

</stripes:layout-definition>
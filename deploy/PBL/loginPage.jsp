<%@include file="/WEB-INF/jsp/commons/taglibs.jsp" %>


<stripes:layout-definition>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="nl" lang="nl">
<head>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<title>${pageTitle}</title>

	<meta name="description" content="" />
	<meta name="keywords" content="" />
	<meta name="distribution" content="global" />
	<meta name="robots" content="index, follow" />
	<meta name="language" content="nl" />

	<link rel="stylesheet" href="${contextPath}/scripts/mde/styles/jquery-ui-latest.custom.css" type="text/css" media="screen" />
	<link rel="stylesheet" href="${contextPath}/styles/screen.css" type="text/css" media="screen" />
	<!--[if IE 8]><link rel="stylesheet" href="${contextPath}/styles/ie/ie8.css" type="text/css" media="screen" /><![endif]-->
	<!--[if lte IE 7]><link rel="stylesheet" href="${contextPath}/styles/ie/ie7.css" type="text/css" media="screen" /><![endif]-->
	<!--[if lte IE 6]><link rel="stylesheet" href="${contextPath}/styles/ie/ie6.css" type="text/css" media="screen" /><![endif]-->
	<link rel="stylesheet" href="${contextPath}/styles/print.css" type="text/css" media="print" />

	<link rel="shortcut icon" href="${contextPath}/images/favicon.ico" type="image/x-icon" />

    <script type="text/javascript" src="${contextPath}/scripts/mde/includes/jquery/jquery-latest.js"></script>
    <script type="text/javascript" src="${contextPath}/scripts/jquery.cookie/jquery.cookie.js"></script>

</head>
<body id="login">

	<div class="container equalize">

		<div class="header">
			<span></span>
            <%@include file="/WEB-INF/jsp/commons/branding.jsp" %>
		</div>

		<div class="content_wrapper1"><div class="content_wrapper2">

			<div class="content">

			<!-- START : CONTENT -->

                <stripes:layout-component name="messages"/>

				<div class="content_main">

                    <stripes:layout-component name="content"/>

				</div>

			<!-- END : CONTENT -->

			</div>

		</div></div>

		<div class="footer">
				&nbsp; <!-- this 'space' is necessary to display the bottom border shadow!!! -->
			<span></span>
		</div>

	</div>

</body>
</html>

</stripes:layout-definition>
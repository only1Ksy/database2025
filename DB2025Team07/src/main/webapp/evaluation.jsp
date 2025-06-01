<%@ page contentType="text/html; charset=UTF-8" %>

<%

	// 현재 로그인한 사용자 ID (세션에서 가져옴)
	String evaluatorId = (String) session.getAttribute("user_id");
	if (evaluatorId == null) {
	    response.sendRedirect("signup.jsp"); 
	    return;
	}
	
	// 파라미터로 전달된 recruit_id 가져오기
    String recruitId = request.getParameter("recruit_id");

    if (recruitId == null) {
        out.println("파라미터가 제대로 전달되지 않았습니다.");
        return;
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>평가하기</title>
</head>
<body>

  <%@ include file="navbar.jsp" %>

  <h2>평가하기</h2>
  <form action="EvaluationSubmitServlet" method="post">
    <input type="hidden" name="recruit_id" value="<%= recruitId %>">
    <input type="hidden" name="evaluator_id" value="<%= evaluatorId %>">

    <label for="score">점수 (1~5):</label>
    <select name="score" required>
        <option value="1">1점</option>
        <option value="2">2점</option>
        <option value="3">3점</option>
        <option value="4">4점</option>
        <option value="5">5점</option>
    </select><br><br>

    <label for="description">평가 내용:</label><br>
    <textarea name="description" rows="4" cols="50"></textarea><br><br>

    <input type="submit" value="평가 제출">
</form>

</body>
</html>

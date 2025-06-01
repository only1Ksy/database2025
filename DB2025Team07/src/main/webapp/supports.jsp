<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="java.sql.Timestamp" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    // 서블릿에서 전달된 속성 가져오기
    String currentUserId = (String) request.getAttribute("userId");
    Integer recruitId = (Integer) request.getAttribute("recruitId");
    List<Map<String, Object>> supportList = (List<Map<String, Object>>) request.getAttribute("supportList");

    // JSP에 supportList가 제대로 넘어왔는지 확인
    if (supportList == null) {
        System.out.println("[supports.jsp] supportList is NULL");
    } 

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    
 	// 전체 지원 목록 중 '채택' 상태가 있는지 확인
    boolean isAccepted = false;
    if (supportList != null) {
        for (Map<String, Object> s : supportList) {
            Object stateObj = s.get("RECRUITMENT_STATE");
            if ("채택됨".equals(String.valueOf(stateObj))) {
            	isAccepted = true;
                break;
            }
        }
    }
%>

<html>
<head>
    <title>모집글 ID <%= (recruitId) %>의 지원자 목록</title>
</head>
<body>
    <%@ include file="navbar.jsp" %>

    <h2>모집글 ID <%= (recruitId) %> 에 대한 지원자 목록</h2>

    <%
        if (supportList == null || supportList.isEmpty()) {
    %>
        <p>이 모집글에 대한 지원자가 없습니다.</p>
        <% if (supportList == null) { %>
            <p>(supportList 객체가 null)</p>
        <% } %>
    <%
        } else {
    %>
        <table border="1">
            <thead>
                <tr>
                    <th>지원자 ID</th>
                    <th>닉네임</th>
                    <th>이메일</th>
                    <th>전화번호</th>
                    <th>평점</th>
                    <th>지원상태</th>
                    <th>지원서</th>
                    <th>지원일</th>
                </tr>
            </thead>
            <tbody>
                <%
                    for (Map<String, Object> support : supportList) {
                        String supporterUserId = (String) support.get("USER_ID");
                        String nickname = (String) support.get("nickname");
                        String email = (String) support.get("email");
                        String phone = (String) support.get("phone");
                        BigDecimal rating = (BigDecimal) support.get("rating");
                        String recruitmentState = (String) support.get("RECRUITMENT_STATE");
                        String supportText = (String) support.get("SUPPORT_TEXT");
                        Timestamp supportCreatedAt = (Timestamp) support.get("SUPPORT_CREATED_AT");
                        Integer supportRecruitId = (Integer) support.get("RECRUIT_ID");

                        String formattedSupportDate = "";
                        if (supportCreatedAt != null) {
                            formattedSupportDate = sdf.format(supportCreatedAt);
                        }
                %>
                    <tr>
                        <td><%= supporterUserId %></td>
                        <td><%= nickname %></td>
                        <td><%= email %></td>
                        <td><%= phone %></td>
                        <td><%= (rating != null ? rating.toString() : "N/A") %></td>
                        <td><%= recruitmentState %></td>
                        <td><%= supportText %></td>
                        <td><%= formattedSupportDate %></td>
                        <td><%
                                // 이미 누군가 채택되었다면
                                if (!isAccepted) {
                                	%>
                                    <a href="AcceptSupportServlet?recruit_id=<%= supportRecruitId %>&user_id=<%= supporterUserId %>">채택하기</a>
									<%
                                }
                            %>
                          </td>                  
                    </tr>
                <%
                    } // end for
                %>
            </tbody>
        </table>
    <%
        } // end if-else
    %>

    <br>
    <a href="my_recruits.jsp">← 내가 작성한 모집글로 돌아가기</a>

</body>
</html>

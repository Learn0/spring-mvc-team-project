<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%><!-- 날짜변환 (오라클/자바) -->
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">

<style type="text/css">
.container1{
   margin-top: 30px;
 
   height:1500px;
}
.row{
  padding-top:20px;
  margin: 0px auto;
  width:1100px;
}
h1,h2{
  text-align: center;
}
</style>
</head>
<body>
   <div class="container1">
   
    <h2>홍보 웹툰</h2>
    <div class="row">
      <table class="table">
       <tr>
         <td>
         <sec:authorize access="hasRole('ROLE_ADMIN')">
          <a href="insert.do" class="btn btn-sm btn-danger">새글</a>
          </sec:authorize>
         </td>
       </tr>
      </table>
      <table class="table">
        <tr class="info">
          <th class="text-center" width=10%>번호</th>
          <th class="text-center" width=45%>제목</th><%-- 댓글 갯수 --%>
          <th class="text-center" width=15%>이름</th>
          <th class="text-center" width=20%>작성일</th>
          <th class="text-center" width=10%>조회수</th>
        </tr>
        <c:forEach var="vo" items="${list }">
         <tr>
          <td class="text-center" width=10%>${vo.no }</td>
          <td class="text-left" width=45%>
           <a href="detail.do?no=${vo.no }&page=${curpage}">${vo.subject }</a>
           <%-- 모든 데이터에 값이 존재하면 (int no) --%>
          </td><%-- 댓글 갯수 --%>
          <td class="text-center" width=15%>${vo.name }</td>
          <td class="text-center" width=20%><%-- <fmt:formatDate value="${vo.regdate }" pattern="yyyy-MM-dd"/> --%>
            ${vo.regdate }
          </td>
          <%--
                  fmt:formatDate => SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd")
           --%>
          <td class="text-center" width=10%>${vo.hit }</td>
         </tr>
        </c:forEach>
      </table>
      <table class="table">
       <tr>
         <td class="text-left">
          <form method=post action="find.do">
	          <input type="checkbox" name="fsArr" value="N">이름
	          <input type="checkbox" name="fsArr" value="S">제목
	          <input type="checkbox" name="fsArr" value="C">내용
	          <%-- 동적 쿼리 --%>
	          <input type=text name=ss size=15 class="input-sm">
	          <button class="btn btn-sm btn-primary">검색</button>
          </form>
         </td>
         <td class="text-right">
           <ul class="pagination">
             <c:if test="${startPage>1 }">
              <li><a href="list.do?page=${startPage-1 }">&lt;</a></li>
             </c:if>
               <c:forEach var="i" begin="${startPage }" end="${endPage }" step="1">
                <c:if test="${curpage==i }">
                  <c:set var="style" value="class=active"/>
                </c:if>
                <c:if test="${curpage!=i }">
                  <c:set var="style" value=""/>
                </c:if>
                <li ${style }><a href="list.do?page=${i }">${i }</a></li>
               </c:forEach>
             <c:if test="${endPage<totalpage }">
			  <li><a href="list.do?page=${endPage+1 }">&gt;</a></li>
			 </c:if>
			</ul>
         </td>
       </tr>
      </table>
    </div>
   </div>
</body>
</html>


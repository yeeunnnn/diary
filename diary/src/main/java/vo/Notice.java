package vo;
//notice 테이블의 한행(레코드)을 저장하는 용도
//Value Object or Data Transfer Object or Domain (select할 때 as Notice로 맞춰줌. 알리오?..알리스?..) 외부 라이브러리 있음. 대문자 다루는 방법이 다름.
public class Notice { //한 행을 저장하는 타입. db에서는 _ 인 게 여기서는 카멜 표현
	public int noticeNo;
	public String noticeTitle; //mariadb에서 int여도 여기서는 double일 수도 있음.
	public String noticeContent;
	public String noticeWriter;
	public String createdate; //java.util.Date/Calendar < java.sql.Date 인데. sql은 설정할 게 많고, util도 결국은 가져와서 모양 맞추는 뭔가를 해야함. 그냥 String가져와서 앞에서 몇글자 자르고 그런게 편함.
	public String updatedate; //그리고 날짜 계산 할거면 DB에서 오늘 날짜 DB로 가져오는 게 편할 수 있음.
	public String noticePw;
}

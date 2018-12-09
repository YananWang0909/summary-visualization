package dao;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import domain.Review;
import utils.JdbcUtils;

public class ReviewDao {
	
	public ArrayList<Review> getReviewForProduct(String productName) throws SQLException {
		ArrayList<Review> reviews= new ArrayList<Review>();
		Connection conn = null;
		PreparedStatement st = null;
		ResultSet rs = null;
		try {
			conn = JdbcUtils.getConnection();
			String sql = "select * from review where ProductName = ?";
			st = conn.prepareStatement(sql);
			st.setString(1, productName);
			rs = st.executeQuery();
			while(rs.next()){
				Review singleReview = new Review();
				singleReview.setId(rs.getInt("id"));
				singleReview.setKeyword(rs.getString("keyword"));
				singleReview.setFeatureWord(rs.getString("featureWord"));
				singleReview.setProductName(rs.getString("productName"));
				singleReview.setReviewContent(rs.getString("reviewContent"));
				singleReview.setSentiment(rs.getInt("sentiment"));
				reviews.add(singleReview);
			}
			return reviews;
		} finally {
			JdbcUtils.release(conn, st, rs);
		}
	}

}

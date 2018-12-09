package function;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;

import com.google.gson.Gson;

import dao.ReviewDao;
import domain.BarData;
import domain.KeyContent;
import domain.RadarData;
import domain.ReturnData;
import domain.Review;
import domain.keyInd;

public class getEcharts {
	int total;
	// Gson gson = new Gson();

	public String getEchatsData(String productName) throws SQLException {

		// public static void main(String [] args) throws SQLException{
		// 校验输入

		if (productName.equals("") || productName == null)
			return null;

		// 声明dao
		ReviewDao d = new ReviewDao();
		// 数据库查id（字符串类型），通过name和occupation
		ArrayList<Review> reviews = d.getReviewForProduct(productName);
		ArrayList<String> keywordList = new ArrayList<String>();
		ArrayList<Integer> keywordPositive = new ArrayList<Integer>();
		ArrayList<Integer> keywordNeutual = new ArrayList<Integer>();
		ArrayList<Integer> keywordNegative = new ArrayList<Integer>();
		ArrayList<Integer> keywordNum = new ArrayList<Integer>();
		for (int i = 0; i < reviews.size(); i++) {
			if (!keywordList.contains(reviews.get(i).getKeyword())) {
				keywordList.add(reviews.get(i).getKeyword());
				if (reviews.get(i).getSentiment() == 0) {
					keywordNeutual.add(1);
					keywordPositive.add(0);
					keywordNegative.add(0);
				}
				if (reviews.get(i).getSentiment() == 1) {
					keywordPositive.add(1);
					keywordNeutual.add(0);
					keywordNegative.add(0);
				}
				if (reviews.get(i).getSentiment() == 2) {
					keywordNegative.add(1);
					keywordNeutual.add(0);
					keywordPositive.add(0);
				}
			} else {
				int keyindex = keywordList.indexOf(reviews.get(i).getKeyword());
				if (reviews.get(i).getSentiment() == 0) {
					keywordNeutual.set(keyindex, keywordNeutual.get(keyindex) + 1);
				}
				if (reviews.get(i).getSentiment() == 1) {
					keywordPositive.set(keyindex, keywordPositive.get(keyindex) + 1);
				}
				if (reviews.get(i).getSentiment() == 2) {
					keywordNegative.set(keyindex, keywordNegative.get(keyindex) + 1);
				}
			}
		}
		int sumpos = 0, sumneg = 0, sumneu = 0;
		int k=0;
		while(k<keywordList.size()){
			int sumSingle=keywordPositive.get(k)+keywordNegative.get(k)+keywordNeutual.get(k);
			
			if(sumSingle<10){
				keywordList.remove(k);
				keywordPositive.remove(k);
				keywordNegative.remove(k);
				keywordNeutual.remove(k);
			}else{
				keywordNum.add(sumSingle);
				k=k+1;
			}
		}

		BarData barData = new BarData();
		barData.keywords = keywordList;
		barData.negative = keywordNegative;
		barData.neutral = keywordNeutual;
		barData.positive = keywordPositive;

		RadarData radarData = new RadarData();
		ArrayList<keyInd> radkeywordList = new ArrayList<keyInd>();
		ArrayList<Double> keywordPositiveRate = new ArrayList<Double>();
		ArrayList<Double> keywordNeutualRate = new ArrayList<Double>();
		ArrayList<Double> keywordNegativeRate = new ArrayList<Double>();

		for (int j = 0; j < keywordList.size(); j++) {
			keyInd ki = new keyInd();
			ki.max = 1;
			ki.name = keywordList.get(j);
			radkeywordList.add(ki);
			
			double posR = (double) keywordPositive.get(j) / keywordNum.get(j);
			double negR = (double) keywordNegative.get(j) / keywordNum.get(j);
			double neuR = (double) keywordNeutual.get(j) / keywordNum.get(j);
			
			
			keywordPositiveRate.add(posR);
			keywordNeutualRate.add(neuR);
			keywordNegativeRate.add(negR);
		}
		
		radarData.negative = keywordNegativeRate;
		radarData.positive = keywordPositiveRate;
		radarData.neutral = keywordNeutualRate;
		radarData.keywords = radkeywordList;
		
		ArrayList<KeyContent> kc=new ArrayList<KeyContent>();
		
		for(int b=0;b<keywordList.size();b++){
			KeyContent kcSingle=new KeyContent();
			
			kcSingle.keyword=keywordList.get(b);
			kcSingle.sentences=new ArrayList<String>();
			for (int i = 0; i < reviews.size(); i++) {
				
				if(reviews.get(i).getKeyword().equals(kcSingle.keyword) && (reviews.get(i).getSentiment()==2||reviews.get(i).getSentiment()==0)){
					kcSingle.sentences.add(reviews.get(i).getReviewContent());
				}
			
				
			}
			kc.add(kcSingle);
		}
		

		ReturnData rData = new ReturnData();
		rData.one = barData;
		rData.two = radarData;
		rData.three=kc;

		Gson gson = new Gson();
		String gsonData = gson.toJson(rData);
		return gsonData;

	}

}

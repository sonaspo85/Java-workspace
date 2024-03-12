package main.java.satisfy.modules;

import javafx.beans.property.SimpleStringProperty;
import main.java.satisfy.Common.implementOBJ;

public class resultDB {
    implementOBJ obj = new implementOBJ();
    
    private SimpleStringProperty type;
    private SimpleStringProperty score;
    private SimpleStringProperty ranking;
    
    public resultDB() {
        this.type = new SimpleStringProperty();
        this.score = new SimpleStringProperty();
        this.ranking = new SimpleStringProperty(); 
        
    }
    
    public resultDB(String type, String score, String ranking) {
        this.type = new SimpleStringProperty(type);
        this.score = new SimpleStringProperty(score);
        this.ranking = new SimpleStringProperty(ranking);
        
        
    }
    
    public String getType() {
        return type.get();
    }
    
    public void setType(String name) {
        this.type.set(name);
    }
    
    public String getScore() {
        return score.get();
    }
    
    public void setScore(String korean) {
        this.score.set(korean);
    }
    
    public String getRanking() {
        return ranking.get();
    }
    
    public void setRanking(String korean) {
        this.ranking.set(korean);
    }
    
    
    
    
    
}

package models;

public class Employee {
	private int id;
	private String name;
	private String speciality;
	private boolean qualified;
	
	
	public Employee(int id, String name, String speciality, boolean qualified) {
		super();
		this.id = id;
		this.name = name;
		this.speciality = speciality;
		this.qualified = qualified;
	}
	
	
	public int getID() {
		return id;
	}
	public void setID(int iD) {
		id = iD;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		name = name;
	}
	public String getSpeciality() {
		return speciality;
	}
	public void setSpeciality(String speciality) {
		this.speciality = speciality;
	}


	public boolean isQualified() {
		return qualified;
	}


	public void setQualified(boolean qualified) {
		this.qualified = qualified;
	}
	
	
}

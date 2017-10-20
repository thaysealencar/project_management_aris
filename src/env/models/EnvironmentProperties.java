package models;

public class EnvironmentProperties {
	
	double newCostP, newTimeP, puccb, putcb;

	public EnvironmentProperties(double newCostP, double newTimeP, double puccb, double putcb) {
		super();
		this.newCostP = newCostP;
		this.newTimeP = newTimeP;
		this.puccb = puccb;
		this.putcb = putcb;
	}

	public double getNewCostP() {
		return newCostP;
	}

	public void setNewCostP(double newCostP) {
		this.newCostP = newCostP;
	}

	public double getNewTimeP() {
		return newTimeP;
	}

	public void setNewTimeP(double newTimeP) {
		this.newTimeP = newTimeP;
	}

	public double getPuccb() {
		return puccb;
	}

	public void setPuccb(double puccb) {
		this.puccb = puccb;
	}

	public double getPutcb() {
		return putcb;
	}

	public void setPutcb(double putcb) {
		this.putcb = putcb;
	}

}

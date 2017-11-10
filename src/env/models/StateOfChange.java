package models;

public class StateOfChange {	
	
	public static final int REQUESTED = 1;
	public static final int APPROVED= 2;
	public static final int REJECTED = 3;
	public static final int OBSOLETE = 4;
	
	public static String getDescription(int sc){
		switch (sc){
		case REQUESTED: return "Requested";
		case APPROVED: return "Approved application";
		case REJECTED: return "Rejected request";
		case OBSOLETE: return "Obsolete request";
		default: return null;
		}
	}

	public static int getRequested() {
		return REQUESTED;
	}

	public static int getApproved() {
		return APPROVED;
	}

	public static int getRejected() {
		return REJECTED;
	}
	
	public static int getObsolete(){
		return OBSOLETE;
	}
	
	
	
}

package co.yj.temp1;

public class DatafileDTO {
	private String tablespaceName;
	private String fileName;
	private int bytes;
	
	
	public String getTablespaceName() {
		return tablespaceName;
	}
	public void setTablespaceName(String tablespaceName) {
		this.tablespaceName = tablespaceName;
	}
	public String getFileName() {
		return fileName;
	}
	public void setFileName(String fileName) {
		this.fileName = fileName;
	}
	public int getBytes() {
		return bytes;
	}
	public void setBytes(int bytes) {
		this.bytes = bytes;
	}
}

package kz.pchelka.daemon.system;

import java.util.ArrayList;

import kz.flabs.webrule.scheduler.DaysOfWeek;


public class LogsZipRule extends SystemDaemonRule{


	@Override
	public int getMinuteInterval() {	
		return 720;
	}

	
	@Override
	public String getClassName() {
		return "kz.pchelka.daemon.system.LogsZip";
	}


	@Override
	public boolean scriptIsValid() {
		return true;
	}


	@Override
	public ArrayList<DaysOfWeek> getDaysOfWeek() {
		ArrayList<DaysOfWeek> daysOfWeek = new ArrayList<DaysOfWeek>();
		daysOfWeek.add(DaysOfWeek.MONDAY);
		daysOfWeek.add(DaysOfWeek.TUESDAY);
		daysOfWeek.add(DaysOfWeek.WEDNESDAY);
		daysOfWeek.add(DaysOfWeek.THURSDAY);
		daysOfWeek.add(DaysOfWeek.FRIDAY);
		daysOfWeek.add(DaysOfWeek.SATURDAY);
		return daysOfWeek;
	}

		
	
}

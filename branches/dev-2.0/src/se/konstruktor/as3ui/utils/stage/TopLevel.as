/**
* @author Alexander Aivars <alexander.aivars@gmail.com>
* 
* Based on com.lessrain.as3lib.utils.stage.TopLevel by Luis Martinez, Less Rain (luis@lessrain.com)
*
* Use TopLevel.getInstance() in the Main Document root class to
* allow global stage access through
* TopLevel.getInstance().stage
*
*/

package se.konstruktor.as3ui.utils.stage
{
	import flash.display.Stage;
	
	public class TopLevel
	{
		
		private static const m_instance:TopLevel = new TopLevel(SingeltonLock);
		private var m_stage  : Stage;
		
		public function TopLevel(lock:Class)
		{
			if (lock != SingeltonLock)
			{
				throw new Error("TopLevel can only be accessed through TopLevel.getInstance().");
			}
		}

		public static function getInstance():TopLevel
		{
			return m_instance;
		}


        /**
        * @param stage_ Main document stage [example: myRootDocument.stage]
        */
        public function set stage(a_stage:Stage):void
        {
            m_stage = a_stage;
        }
        
        public function get stage():Stage
        {
            if(m_stage!=null) return m_stage;
            else return null;
        }
        		
	}
}

internal class SingeltonLock 
{
}
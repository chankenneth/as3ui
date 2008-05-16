package se.konstruktor.as3ui.controls.button
{

	import asunit.framework.AsynchronousTestCase;
	import asunit.framework.TestSuite;
	
	import flash.events.MouseEvent;

	public class BaseButtonTest extends AsynchronousTestCase
	{
		private var m_instance:BaseButton;

		public function BaseButtonTest(methodName:String=null)
		{
			super(methodName)
		}

		public static function suite():TestSuite
		{
   			var ts:TestSuite = new TestSuite();
	 		ts.addTest(new BaseButtonTest());
//	 		ts.addTest(new BaseButtonTest("testInstantiated"));
   			return ts;
   		}

		override protected function setUp():void
		{
			super.setUp();
			m_instance = new BaseButton();
			addChild(m_instance);
		}

		override protected function tearDown():void
		{
			super.tearDown();
			removeChild(m_instance);
			m_instance = null;
		}

		public function testInstantiated():void
		{
			assertTrue("baseButton is BaseButton", m_instance is BaseButton);
		}
		
		public function testPress():void
		{
			var handler:Function = addAsync(resultTestPress, 1000);
			var instance:BaseButton = m_instance;

			instance.addEventListener(ButtonEvent.PRESS, handler);
			instance.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN,true,true,0,0,instance,false,false,false,true,0));
		}
		
		public function resultTestPress(event:ButtonEvent):void
		{
			var instance:BaseButton = event.target as BaseButton;
			assertEquals(ButtonEvent.PRESS, event.type);
			assertEquals(instance.m_state, ButtonState.PRESSED);
			assertTrue(instance.m_isFocus);
		}

		public function testPressAndRelease():void
		{
			var handler:Function = addAsync(resultTestPressAndRelease, 1000);
			var instance:BaseButton = m_instance;

			instance.addEventListener(ButtonEvent.RELEASE, handler);
			instance.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN,true,true,0,0,instance,false,false,false,true,0));
			instance.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP,true,true,0,0,instance,false,false,false,false,0));
		}
		
		public function resultTestPressAndRelease(event:ButtonEvent):void
		{
			var instance:BaseButton = event.target as BaseButton;
			assertEquals(ButtonEvent.RELEASE, event.type);
			assertEquals(ButtonState.RELEASED, instance.m_state);
			assertEquals(false, instance.m_isFocus);
		}

		public function testOver():void
		{
			var handler:Function = addAsync(resultTestOver, 1000);
			var instance:BaseButton = m_instance;

			instance.addEventListener(ButtonEvent.ROLL_OVER, handler);
			instance.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER,true,true,0,0,instance,false,false,false,false,0));
		}
		
		public function resultTestOver(event:ButtonEvent):void
		{
			var instance:BaseButton = event.target as BaseButton;
			assertEquals(ButtonEvent.ROLL_OVER, event.type);
			assertEquals(ButtonState.OVER, instance.m_state);
			assertEquals(false, instance.m_isFocus);
		}
		
		public function testOverAndOut():void
		{
			var handler:Function = addAsync(resultTestOverAndOut, 1000);
			var instance:BaseButton = m_instance;
			
			instance.addEventListener(ButtonEvent.ROLL_OUT, handler);

			instance.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER,true,true,0,0,instance,false,false,false,false,0));
			instance.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT,true,true,0,0,instance,false,false,false,false,0)); 
		}
		
		public function resultTestOverAndOut(event:ButtonEvent):void
		{
			var instance:BaseButton = event.target as BaseButton;
			assertEquals(ButtonEvent.ROLL_OUT, event.type);
			assertEquals(ButtonState.RELEASED, instance.m_state);
			assertEquals(false, instance.m_isFocus);
		}

		public function testPressAndOutAndRelease():void
		{
			var handler:Function = addAsync(resultTestPressAndOutAndRelease, 1000);
			var instance:BaseButton = m_instance;
			instance.addEventListener(ButtonEvent.RELEASE_OUTSIDE, handler);

			instance.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN,true,true,0,0,instance,false,false,false,true,0));
			instance.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT,true,true,0,0,instance,false,false,false,true,0));
			getContext().dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP,true,true,0,0,getContext(),false,false,false,false,0));

		}

		public function resultTestPressAndOutAndRelease(event:ButtonEvent):void
		{
			var instance:BaseButton = event.target as BaseButton;
			
			assertEquals(ButtonEvent.RELEASE_OUTSIDE,event.type);
			assertEquals(ButtonState.RELEASED, instance.m_state);
			assertEquals(false, instance.m_isFocus);
		}

		public function testSetToggled():void
		{
			assertEquals(false, m_instance.isToggled);

			m_instance.setToggled(true);
			assertEquals(true, m_instance.isToggled);
			
			m_instance.setToggled(false);
			assertEquals(false, m_instance.isToggled);
			
		}

		public function testToggledEvent():void
		{
			var handler:Function = addAsync(resultTestToggled, 1000);
			var instance:BaseButton = m_instance;
			instance.addEventListener(ButtonEvent.TOGGLE, handler);
			instance.setToggled(true);
		}

		public function testToggledAndMouseEvent():void
		{
			m_instance.setToggled(true);
			m_instance.addEventListener(ButtonEvent.STATE, resultFailStateEvent);
			
			m_instance.setToggled(true);
			m_instance.addEventListener(ButtonEvent.TOGGLE, resultFailToggledEvent);
			m_instance.setToggled(true);

			m_instance.addEventListener(ButtonEvent.ROLL_OVER, resultTrigerOverEvent);
			m_instance.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER,true,true,0,0,m_instance,false,false,false,false,0));

			m_instance.addEventListener(ButtonEvent.PRESS, resultTrigerPressEvent);
			m_instance.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN,true,true,0,0,m_instance,false,false,false,true,0));
			
			m_instance.addEventListener(ButtonEvent.RELEASE, resultTrigerReleaseEvent);
			m_instance.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP,true,true,0,0,m_instance,false,false,false,false,0));

			m_instance.addEventListener(ButtonEvent.ROLL_OUT, resultTrigerOutEvent);
			m_instance.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OUT,true,true,0,0,m_instance,false,false,false,false,0));
		}

		public function resultFailStateEvent(event:ButtonEvent):void
		{
			assertEquals("resultFailStateEvent should not be trigger", "false");
		}
		
		public function resultFailToggledEvent(event:ButtonEvent):void
		{
			assertEquals("resultFailToggledEvent should not be trigger", "false");
		}

		public function resultTrigerOverEvent(event:ButtonEvent):void
		{
			var instance:BaseButton = event.target as BaseButton;
			assertEquals(ButtonEvent.ROLL_OVER, event.type);
			assertEquals(ButtonState.RELEASED, instance.m_state);
			assertEquals(false, instance.m_isFocus);
		}

		public function resultTrigerPressEvent(event:ButtonEvent):void
		{
			var instance:BaseButton = event.target as BaseButton;
			assertEquals(ButtonEvent.PRESS, event.type);
			assertEquals(ButtonState.RELEASED, instance.m_state);
			assertEquals(true, instance.m_isFocus);
		}

		public function resultTrigerReleaseEvent(event:ButtonEvent):void
		{
			var instance:BaseButton = event.target as BaseButton;
			assertEquals(ButtonEvent.RELEASE, event.type);
			assertEquals(ButtonState.RELEASED, instance.m_state);
			assertEquals(false, instance.m_isFocus);
		}

		public function resultTrigerOutEvent(event:ButtonEvent):void
		{
			var instance:BaseButton = event.target as BaseButton;
			assertEquals(ButtonEvent.ROLL_OUT, event.type);
			assertEquals(ButtonState.RELEASED, instance.m_state);
			assertEquals(false, instance.m_isFocus);
		}

		public function resultTestToggled(event:ButtonEvent):void
		{
			var instance:BaseButton = event.target as BaseButton;
			assertEquals(ButtonEvent.TOGGLE,event.type);
		}
		

	}
}
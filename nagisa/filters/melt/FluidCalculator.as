package nagisa.filters.melt
{
	/**
	 * Reflection 
	 * @author Nagisa
	 * @创建时间 2021-7-16
	 * @修改时间 2021-7-16
	 * @version 1.0.0
	 */
	public class FluidCalculator
	{
		
		//--------------------------------------
		// CLASS CONSTANTS
		//--------------------------------------
		
		//config param
		
		
		//--------------------------------------
		// VARIABLES
		//--------------------------------------
		
		
		//--------------------------------------
		// STAGE INSTANCES
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// GETTER/SETTERS
		//--------------------------------------
		
		
		
		
		
		//--------------------------------------
		// CONSTRUCTOR
		//--------------------------------------
		
		/**
		 * Constructor
		 * @param	
		 */
		public function FluidCalculator(
		):void
		{
		}
		//--------------------------------------
		// UPDATE
		//--------------------------------------
		//--------------------------------------
		// METHODS
		//--------------------------------------
		/**
		 * calc velocity vecror of x
		 * 
		 * | +0.5, 0, -0.5 |
		 * | +1.0, 0, -1.0 |
		 * | +0.5, 0, -0.5 |
		 * 
		 * @param	data
		 * @return
		 */
		public function calcVelocityX(data:FluidData):Number
		{
			return (  data.n00.pressure * 0.5
					+ data.n01.pressure
					+ data.n02.pressure * 0.5
					- data.n20.pressure * 0.5
					- data.n21.pressure
					- data.n22.pressure * 0.5
					
					) * 0.25;
		}
		
		/**
		 * calc velocity vecror of y
		 * 
		 * | +0.5, +1.0, +0.5 |
		 * |  0  ,  0  ,  0   |
		 * | -0.5, -1.0, -0.5 |
		 * 
		 * @param	data
		 * @return
		 */
		public function calcVelocityY(data:FluidData):Number
		{
			return (  data.n00.pressure * 0.5
					+ data.n10.pressure
					+ data.n20.pressure * 0.5
					- data.n02.pressure * 0.5
					- data.n12.pressure
					- data.n22.pressure * 0.5
					
					) * 0.25;
		}
		
		/**
		 * calc pressure value
		 * 
		 * | +0.5, 0, -0.5 |   | +0.5, +1.0, +0.5 |
		 * | +1.0, 0, -1.0 | + |  0  ,  0  ,  0   |
		 * | +0.5, 0, -0.5 |   | -0.5, -1.0, -0.5 |
		 * 
		 * @param	data
		 * @return
		 */
		public function calcPressure(data:FluidData):Number
		{
			return (  data.n00.vx * 0.5
					+ data.n01.vx * 1
					+ data.n02.vx * 0.5
					- data.n20.vx * 0.5
					- data.n21.vx * 1
					- data.n22.vx * 0.5
					
					+ data.n00.vy * 0.5
					+ data.n10.vy * 1
					+ data.n20.vy * 0.5
					- data.n02.vy * 0.5
					- data.n12.vy * 1
					- data.n22.vy * 0.5
					
					) * 0.5;
		}
	}
}
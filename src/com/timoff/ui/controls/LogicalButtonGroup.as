/**
 * Author: Vasily
 * Web: http://timoff.com
 * Date: 19.05.11
 * Time: 9:18
 */
package com.timoff.ui.controls {
import com.timoff.ui.interfaces.ILogicalGroupClient;

	import flash.events.EventDispatcher;
	import flash.events.Event;

	[Event(name="change", type="flash.events.Event")]
	public class LogicalButtonGroup extends EventDispatcher {

		private static var groups:Object;
		private static var groupCount:uint = 0;

		public static function getGroup(name:String):LogicalButtonGroup {
			if (groups == null) { groups = {}; }
			var group:LogicalButtonGroup = groups[name] as LogicalButtonGroup;
			if (group == null) {
				group = new LogicalButtonGroup(name);
				// every so often, we should clean up old groups:
				if ((++groupCount)%20 == 0) {
					cleanUpGroups();
				}
			}
			return group;
		}

        /**
         * @private
         */
		private static function registerGroup(group:LogicalButtonGroup):void {
			if(groups == null){groups = {}}
			groups[group.name] = group;
		}

        private static function cleanUpGroups():void {
			for (var n:String in groups) {
				var group:LogicalButtonGroup = groups[n] as LogicalButtonGroup;
				if (group.clients.length == 0) {
					delete(groups[n]);
				}
			}
		}

		protected var _name:String;
		protected var clients:Array = [];
		protected var _selection:ILogicalGroupClient;

		/**
		 * Creates a new LogicalButtonGroup instance.
		 * This is usually done automatically when a radio button is instantiated.
		 *
         * @param name The name of the radio button group.
		 */
		public function LogicalButtonGroup(name:String) {
			_name = name;
			clients = [];
			registerGroup(this);
		}

		public function get name():String {
			return _name;
		}

		/**
		 * Adds a radio button to the internal radio button array for use with
		 * radio button group indexing, which allows for the selection of a single radio button
		 * in a group of radio buttons.  This method is used automatically by radio buttons,
		 * but can also be manually used to explicitly add a radio button to a group.
		 *
         * @param value The ILogicalGroupClient instance to be added to the current radio button group.
         *
		 */
		public function addClient(value:ILogicalGroupClient):void {
            /*
			if (value.groupName != name) {
				value.groupName = name;
				return;
			}
			*/
			clients.push(value);
			if (value.selected) { selection = value; }
		}

		/**
		 * Clears the ILogicalGroupClient instance from the internal list of radio buttons.
		 *
         * @param value The ILogicalGroupClient instance to remove.
         *
		 */
		public function removeClient(value:ILogicalGroupClient):void {
			var i:int = getILogicalGroupClientIndex(value);
			if (i != -1) {
				clients.splice(i, 1);
			}
			if (_selection == value) { _selection = null; }
		}

		/**
		 * Gets or sets a reference to the radio button that is currently selected
         * from the radio button group.
         *
         * @includeExample examples/LogicalButtonGroup.selection.1.as -noswf
         *
		 */
		public function get selection():ILogicalGroupClient {
			return _selection;
		}

		/**
         * @private (setter)
         *
		 */
		public function set selection(value:ILogicalGroupClient):void {
			if (_selection == value || (getILogicalGroupClientIndex(value) == -1 && value != null )) { return; }
			_selection = value;
			dispatchEvent(new Event(Event.CHANGE, true));
		}

		/**
         * Gets or sets the selected radio button's <code>value</code> property.
         * If no radio button is currently selected, this property is <code>null</code>.
         *
         * @includeExample examples/LogicalButtonGroup.selectedData.1.as -noswf
         *
		 */



		/**
		 * Returns the index of the specified ILogicalGroupClient instance.
		 *
		 * @param client The ILogicalGroupClient instance to locate in the current LogicalButtonGroup.
		 *
         * @return The index of the specified ILogicalGroupClient component, or -1 if the specified ILogicalGroupClient was not found.
         *
		 */
		public function getILogicalGroupClientIndex(client:ILogicalGroupClient):int {
			for (var i:int = 0; i < clients.length; i++) {
				var cl:ILogicalGroupClient = clients[i] as ILogicalGroupClient;

				if(cl == client) {
					return i;
				}
			}
			return -1;
		}

		/**
		 * Retrieves the ILogicalGroupClient component at the specified index location.
		 *
         * @param index The index of the ILogicalGroupClient component in the LogicalButtonGroup component,
         *        where the index of the first component is 0.
		 *
         * @return The specified ILogicalGroupClient component.
		 *
         * @throws RangeError The specified index is less than 0 or greater than or equal to the length of the data provider.
         *
		 */
		public function getILogicalGroupClientAt(index:int):ILogicalGroupClient {
			return ILogicalGroupClient(clients[index]);
		}

		/**
		 * Gets the number of radio buttons in this radio button group.
         *
         * @default 0
         *
		 */
		public function get numILogicalGroupClients():int {
			return clients.length;
		}
	}
}

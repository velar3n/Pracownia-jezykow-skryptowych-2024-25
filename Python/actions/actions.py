from typing import Any, Text, Dict, List

from rasa_sdk import Action, Tracker
from rasa_sdk.executor import CollectingDispatcher
from rasa_sdk.events import SlotSet
from datetime import datetime
import json


class ActionIsOpenNow(Action):

    def name(self) -> Text:
        return "action_is_open_now"

    def run(self, dispatcher: CollectingDispatcher, tracker: Tracker, domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        with open('data/opening_hours.json') as file:
            data = json.load(file)
            day = datetime.now().strftime('%A').lower().capitalize()
            hours = data['items'].get(day)
            current_hour = datetime.now().hour

            if hours['open'] <= current_hour < hours['close']:
                dispatcher.utter_message(text="The restaurant is currently open.")
            else:
                dispatcher.utter_message(text="The restaurant is currently closed.")
        return []
    

class ActionIsOpenOnTime(Action):

    def name(self) -> Text:
        return "action_is_open_on_time"

    def run(self, dispatcher: CollectingDispatcher, tracker: Tracker, domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        with open('data/opening_hours.json') as file:
            data = json.load(file)
            day = tracker.get_slot('day').lower().capitalize()
            hour = tracker.get_slot('hour')
            hours = data['items'].get(day)

            if 'AM' in hour or 'PM' in hour:
                hour = datetime.strptime(hour, '%I:%M%p').hour
            else:
                hour = datetime.strptime(hour, '%H:%M').hour            
            
            if hours['open'] <= hour < hours['close']:
                dispatcher.utter_message(text="Yes, we are open then.")
            else:
                dispatcher.utter_message(text="No, we are closed then.")
        return []
    

class ActionIsOpenOnDay(Action):

    def name(self) -> Text:
        return "action_is_open_on_day"

    def run(self, dispatcher: CollectingDispatcher, tracker: Tracker, domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        with open('data/opening_hours.json') as file:
            data = json.load(file)
            day = tracker.get_slot('day').lower().capitalize()
            hours = data['items'].get(day)
            
            if hours['open'] == hours['close']:
                dispatcher.utter_message(text=f"On {day} we are closed.")
            else:
                dispatcher.utter_message(text=f"On {day} we are open: {hours['open']}-{hours['close']}.")
        return []
    

class ActionListMenu(Action):

    def name(self) -> Text:
        return "action_list_menu"

    def run(self, dispatcher: CollectingDispatcher, tracker: Tracker, domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        with open('data/menu.json') as file:
            data = json.load(file)
            message = "Our menu:\n"
            
            for item in data['items']:
                name = item['name']
                price = item['price']
                message += f"{name}: ${price}\n"
                
            dispatcher.utter_message(text=message)
        return []
    

class ActionPlaceOrder(Action):

    def name(self) -> Text:
        return "action_place_order"

    def run(self, dispatcher: CollectingDispatcher, tracker: Tracker, domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        with open('data/menu.json') as file:
            menu = [menu_item["name"].strip().lower() for menu_item in json.load(file)["items"]]\
            
            item = tracker.get_slot("item") or None
            keyword = tracker.get_slot("extra_keyword") or None
            extra_item = tracker.get_slot("extra_item") or None
            order_summary = tracker.get_slot("order") or []
            
            if item in menu:
                if keyword and extra_item:
                    order_summary.append(f"{item} {keyword} {extra_item}")
                else:
                    order_summary.append(f"{item}")
                dispatcher.utter_message(text=f"I added {item} to your order. Do you want to order anything else?")
                return [SlotSet("item", None), SlotSet("order", order_summary), SlotSet("extra_keyword", None), SlotSet("extra_item", None)]
            else:
                dispatcher.utter_message(text=f"We don't have {item} in the menu. Do you want to order anything else?")
                return [SlotSet("item", None), SlotSet("extra_keyword", None), SlotSet("extra_item", None)]
            

class ActionConfirmOrder(Action):

    def name(self) -> Text:
        return "action_confirm_order"

    def run(self, dispatcher: CollectingDispatcher, tracker: Tracker, domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        order_summary = tracker.get_slot("order")

        if not order_summary:
            dispatcher.utter_message("You didn't order anything.")
        else:
            message = "This is your order: \n"
            for item in order_summary:
                message += f"  {item}\n"                
            dispatcher.utter_message(text=message)
        return []
    

class ActionConfirmPickup(Action):

    def name(self) -> Text:
        return "action_confirm_pick_up"

    def run(self, dispatcher: CollectingDispatcher, tracker: Tracker, domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        with open('data/menu.json') as file:
            menu = json.load(file)["items"]
            
            order_summary = tracker.get_slot("order")
            if not order_summary or len(order_summary) == 0:
                dispatcher.utter_message("Empty order, add something")
                return []
            
            time = 0
            price = 0
            
            for order in order_summary:
                for dish in menu:
                    if dish["name"] == order.split()[0].lower().capitalize():
                        time += dish["preparation_time"]
                        price += dish["price"]
                             
            dispatcher.utter_message(f"Order will be available for pick-up in {time} hours")
            dispatcher.utter_message(f"Price: {price}")
            
            return [SlotSet("order", None)]
        

class ActionConfirmDelivery(Action):

    def name(self) -> Text:
        return "action_confirm_delivery"

    def run(self, dispatcher: CollectingDispatcher, tracker: Tracker, domain: Dict[Text, Any]) -> List[Dict[Text, Any]]:
        with open('data/menu.json') as file:
            menu = json.load(file)["items"]

        address = tracker.get_slot("address")
        order_summary = tracker.get_slot("order")
        if not order_summary or len(order_summary) == 0:
            dispatcher.utter_message("Empty order, add something")
            return []
        
        price = 0

        for order in order_summary:
            for dish in menu:
                if dish["name"] == order.split()[0].lower().capitalize():
                    price += dish["price"]

        if not address:
            dispatcher.utter_message(text="Sorry. Something get wrong. You can pick-up your food.")
            dispatcher.utter_message(f"Price: {price}")
        else:
            dispatcher.utter_message(f"Thank you for the order. It will be delivered to {address}")
            dispatcher.utter_message(f"Price: {price}")
        return [SlotSet("order", None)]
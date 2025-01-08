# Rasa-based chatbot for a restaurant with Slack integration

## Author: Natalia Kiełbasa

This is a Rasa-based chatbot to assist restaurant customes. The chatbot can handle inquiries about opening hours, list menu items, process orders (including customizations and additional requests), and confirm pick-up or delivery details.

## Prerequisites
1. Python
2. Rasa
   - Install Rasa using:
     ```bash
     pip install rasa
     ```
3. Slack
4. Ngrok


## Set it up
This script runs in a Bash environment:
1. Clone the repository
2. Add slack credentials to credentials.yml 
3. Train the model
```bash
rasa train
```
4. Start the Rasa server
```bash
rasa run
```
5. Run the action server
```bash
rasa run actions
```
6. Use ngrok for tunneling to connect your local chatbot to Slack

Now you can start chatting :>
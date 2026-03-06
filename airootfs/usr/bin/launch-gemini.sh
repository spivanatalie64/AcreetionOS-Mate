#!/bin/bash

# Disclaimer Popup
zenity --warning \
    --title="AI Usage Disclaimer" \
    --width=400 \
    --text="<b>Important Notice:</b>\n\nYou are about to access Google Gemini, an Artificial Intelligence tool.\n\n<b>Please be aware:</b>\n\n1. AI models can 'hallucinate' or provide incorrect information.\n2. Always verify important facts with 2-3 other reliable sources.\n3. If you are unsure about something, please ask in our Discord community.\n\nProceed with caution and verify everything." \
    --ok-label="I Understand, Launch Gemini"

# Launch Gemini if user clicks OK (if they cancel, zenity returns non-zero and script exits if set to -e, but here we just continue if 0)
if [ $? -eq 0 ]; then
    xdg-open "https://gemini.google.com"
fi

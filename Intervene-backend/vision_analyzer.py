"""
vision_analyzer.py - Module for analyzing screenshots using locally hosted LLaVA
"""
import logging
import base64
from langchain_community.llms import Ollama
import os
from config import get_ollama_config

# Configure logging
logger = logging.getLogger(__name__)

# Get Ollama configuration from environment
ollama_config = get_ollama_config()
VISION_MODEL = ollama_config["vision_model"]
LOCAL_OLLAMA_URL = ollama_config["base_url"]

def analyze_screenshot(image_path):
    """
    Analyze a screenshot using LLaVA vision model
    
    Args:
        image_path (str): Path to the screenshot image file
        
    Returns:
        str: Analysis of the screenshot
    """
    try:
        # Encode image as base64
        with open(image_path, "rb") as image_file:
            base64_image = base64.b64encode(image_file.read()).decode('utf-8')
        
        logger.info(f"Analyzing screenshot using {VISION_MODEL}")
        
        # Prepare the prompt for vision analysis
        prompt = f"""
        Analyze this screenshot and tell me:
        1. What application is visible?
        2. What is the main content or context?
        3. What tasks could be performed here?
        
        Be concise and focus on actionable insights.
        """
        
        # Set up the Ollama vision model with local endpoint
        llava = Ollama(model=VISION_MODEL, base_url=LOCAL_OLLAMA_URL)
        
        # Create multimodal message with image and text
        response = llava.invoke({
            "prompt": prompt,
            "images": [base64_image]
        })
        
        logger.info("Screenshot analysis completed")
        return response.strip()
        
    except Exception as e:
        logger.error(f"Error analyzing screenshot: {str(e)}")
        return f"Error analyzing screenshot: {str(e)}"
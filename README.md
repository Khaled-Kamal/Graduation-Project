# Smart Land 

![Smart Land Banner]

![Image](https://github.com/user-attachments/assets/1c7189f4-5823-49a7-9ed4-90146fef5671)



> **Intelligent Agricultural Assistant Mobile Application** - Empowering farmers with AI-driven insights, soil fertility analysis, and accessible agricultural knowledge.

## 🚀 Overview

Smart Land is a mobile application designed to revolutionize agricultural decision-making for farmers, agricultural engineers, and enthusiasts. Powered by artificial intelligence, it offers real-time support through a bilingual chatbot, soil fertility analysis, and a comprehensive knowledge base, making expert agricultural guidance accessible anytime, anywhere.

## ✨ Key Features

### 🤖 **AI-Powered Chatbot**
- Bilingual support (Arabic and English, including Egyptian colloquial dialect)
- Answers queries on crops, soil, fertilizers, irrigation, pest control, and more
- Trained on a dataset of ~15,000 agricultural questions using LLaMA3 8B-Instruct model
- Provides context-aware, practical recommendations

### 🌱 **Soil Fertility Analyzer**
- Machine learning model (Random Forest Classifier) to predict soil fertility (Low, Medium, High)
- Accepts inputs like Nitrogen (N), Phosphorus (P), Potassium (K), pH, and other soil properties
- Helps users make informed decisions on crop selection and soil treatment

### 📚 **Knowledge Base**
- Detailed information on crops, plants, fertilizers, and pesticides
- FAQ section with offline access for quick reference
- Practical tips on sustainable farming and agricultural techniques

### 👤 **User Management**
- Secure registration and login with OTP email verification
- Password reset functionality
- Guest mode for exploring features without signup
- User profile management with customizable settings

### 🔔 **Additional Features**
- Notification system for updates and alerts
- Filterable categories for crops, fertilizers, and plants
- User-friendly interface optimized for farmers and non-technical users

## 🛠️ Technology Stack

- **Frontend**: Flutter (cross-platform mobile app for Android and iOS)
- **Backend**: ASP.NET Core Web API, FastAPI (for AI model integration)
- **Database**: SQL Server (relational database with normalized schema)
- **AI/ML**: LLaMA3 8B-Instruct (chatbot), Random Forest Classifier (soil analysis)
- **Design**: Figma (UI/UX prototyping and wireframes)
- **Libraries**:
  - Flutter: `dio`, `image_picker`, `provider`, `chat_bubbles`, `animate_do`
  - Python: `pandas`, `numpy`, `sklearn`, `joblib`, `matplotlib`, `seaborn`
  - AI: `transformers`, `peft`, `trl`, `bitsandbytes`
- **Deployment**: Google Colab, Kaggle Notebooks, Hugging Face (model hosting), Gradio (chatbot UI), Ngrok (API tunneling)
- **Testing**: Unit, Integration, System, and Acceptance Testing

## 📁 Project Structure
smart-land/
├── SmartLand.Mobile/               # Flutter Frontend
│   ├── lib/                       # Dart source code
│   │   ├── screens/              # UI screens (Home, Chat, Soil Analyzer, etc.)
│   │   ├── widgets/              # Reusable UI components
│   │   ├── services/             # API and data services
│   │   └── main.dart             # Application entry point
│   ├── assets/                   # Images, fonts, and static files
│   └── pubspec.yaml              # Flutter dependencies
│
├── SmartLand.Backend/             # ASP.NET Core Backend
│   ├── Controllers/               # API controllers
│   ├── Models/                   # Data models (User, Crop, Fertilizer, etc.)
│   ├── Services/                 # Business logic services
│   ├── Data/                     # Entity Framework Core DbContext
│   ├── Migrations/               # Database migrations
│   └── appsettings.json          # Configuration settings
│
├── SmartLand.AI/                  # AI Models and Scripts
│   ├── chatbot/                  # LLaMA3 fine-tuning scripts
│   ├── soil_fertility/           # Random Forest model scripts
│   ├── datasets/                 # Training datasets
│   └── api/                      # FastAPI for model deployment
│
└── SmartLand.sln                  # Solution file

## 🚦 Getting Started

### Prerequisites
- Flutter SDK (v3.x or higher)
- .NET Core SDK (v8.0 or higher)
- Python 3.9+
- SQL Server (LocalDB, Express, or Full)
- Git
- Google Colab or Kaggle account (for AI model training)
- Hugging Face account (for model hosting)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/smart-land.git
   cd smart-land
### Installation

2. **Install Flutter dependencies**
   ```bash
   cd SmartLand.Mobile
   flutter pub get
3. **Restore .NET packages**
   ```bash
   cd ../SmartLand.Backend
   dotnet restore
4. **Set up Python environment for AI**
   ```bash
   cd ../SmartLand.AI
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   pip install -r requirements.txt

5. **Database Setup**
   Update connection string in `SmartLand.Backend/appsettings.json`:
   ```json
   {
     "ConnectionStrings": {
       "DefaultConnection": "Server=(localdb)\\mssqllocaldb;Database=SmartLandDB;Trusted_Connection=True;"
     }
   }

6. **Environment Setup**
   Configure API keys and settings in `SmartLand.AI/api/config.py` for Hugging Face, Ngrok, and FastAPI:
   ```python
   HUGGINGFACE_TOKEN = "your-huggingface-token"
   NGROK_AUTH_TOKEN = "your-ngrok-auth-token"

  
```markdown
7. **Run the Application**
   - **Backend**: 
     ```bash
     cd SmartLand.Backend
     dotnet run
     ```
   - **Frontend**:
     ```bash
     cd SmartLand.Mobile
     flutter run
     ```
   - **AI API**:
     ```bash
     cd SmartLand.AI/api
     uvicorn main:app --reload
     ```

## 📚 API Documentation

### Base URL
```
https://localhost:5001/api/v1
```

### Authentication Endpoints
```http
POST /api/v1/auth/register          # User registration with OTP
POST /api/v1/auth/login             # User login
POST /api/v1/auth/forgot-password   # Request password reset
POST /api/v1/auth/verify-otp        # Verify OTP for password reset
POST /api/v1/auth/reset-password    # Reset password
POST /api/v1/auth/logout            # User logout
```

### Chatbot Endpoints
```http
POST /api/v1/chatbot/query          # Submit agricultural question
GET  /api/v1/chatbot/history        # Get chat history
```

### Soil Analyzer Endpoints
```http
POST /api/v1/soil/analyze           # Submit soil data for fertility prediction
GET  /api/v1/soil/history           # Get soil analysis history
```

### Knowledge Base Endpoints
```http
GET /api/v1/knowledge/crops         # List all crops
GET /api/v1/knowledge/fertilizers   # List all fertilizers
GET /api/v1/knowledge/plants        # List all plants
GET /api/v1/knowledge/faqs          # List FAQs
```

For complete API documentation, visit: `http://localhost:5001/swagger`

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

Graduation Project 2025, Faculty of Computers and Information - Kafr El-Sheikh University

## 👥 Team

- **Khaled Kamal Ali** - [GitHub Profile](https://github.com/Khaled-Kamal)
- **Nahla Mohammed Saeed** 
- **Khalid Ghonem AbdLhamid** 
- **Samar Basuny Haidar** 
- **Gaber Mohammed Lotfi** 
- **Esraa AbdElfttah Mohammed** - [GitHub Profile](https://github.com/esraa-abdelfttah)
- **Hussien Talha Hussien** 
- **Khaled Waled Mohammed** 
- **Supervisor**: Assoc. Prof. Reda M. Hussien

## 📞 Support

For support and questions:
- 📧 Email:  KhaledKamal14t@outlook.sa
- Phone : 01090662441
- 📖 Documentation: [Swagger API Docs](http://localhost:5001/swagger)

---

**⭐ Star this repo if you find it helpful!**
```

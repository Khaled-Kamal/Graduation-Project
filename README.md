# 🌍 Smart Land

> **Intelligent Agricultural Assistant Mobile Application**
> Empowering farmers with **AI-driven insights**, **soil fertility analysis**, and **accessible agricultural knowledge**..

---

## 🚀 Overview

**Smart Land** is a mobile application designed to transform agricultural decision-making for farmers, engineers, and enthusiasts.
It leverages **AI** to deliver real-time support through a bilingual chatbot, soil fertility analysis, and a knowledge base, making expert agricultural guidance accessible **anytime, anywhere**.

---

## ✨ Features

### 🤖 AI-Powered Chatbot

* Bilingual: **Arabic (Standard + Egyptian dialect)** & **English**
* Answers queries on crops, soil, fertilizers, irrigation, pest control, etc.
* Trained on **15,000+ agricultural questions** (LLaMA3 8B-Instruct)
* Provides **context-aware, practical recommendations**

### 🌱 Soil Fertility Analyzer

* Predicts fertility levels (**Low, Medium, High**)
* Uses **Random Forest Classifier** with soil inputs: N, P, K, pH, etc.
* Guides on crop selection & soil treatment

### 📚 Knowledge Base

* Detailed info on **crops, plants, fertilizers, and pesticides**
* **Offline FAQ** for quick reference
* Practical tips on **sustainable farming**

### 👤 User Management

* Secure registration & login with **OTP verification**
* Password reset & guest mode
* User profile customization

### 🔔 Additional Features

* Push notifications for updates & alerts
* Category filters (crops, fertilizers, plants)
* **Farmer-friendly UI** designed for simplicity

---

## 🛠 Technology Stack

| Layer          | Technologies                                                |
| -------------- | ----------------------------------------------------------- |
| **Frontend**   | Flutter (Android + iOS)                                     |
| **Backend**    | ASP.NET Core Web API, FastAPI                               |
| **Database**   | SQL Server (EF Core)                                        |
| **AI/ML**      | LLaMA3 8B-Instruct (chatbot), Random Forest (soil analyzer) |
| **Design**     | Figma                                                       |
| **Deployment** | Hugging Face, Gradio, Colab, Kaggle, Ngrok                  |

**Libraries**:

* **Flutter** → `dio`, `provider`, `chat_bubbles`, `image_picker`, `animate_do`
* **Python** → `pandas`, `numpy`, `scikit-learn`, `joblib`, `matplotlib`
* **AI** → `transformers`, `peft`, `trl`, `bitsandbytes`

---

## 📁 Project Structure

```plaintext
smart-land/
├── SmartLand.Mobile/       # Flutter Frontend
│   ├── lib/               # Dart source code
│   │   ├── screens/       # UI (Home, Chat, Soil Analyzer…)
│   │   ├── widgets/       # Reusable components
│   │   ├── services/      # API & data services
│   │   └── main.dart      # Entry point
│   ├── assets/            # Images, fonts, static files
│   └── pubspec.yaml       # Flutter dependencies
│
├── SmartLand.Backend/      # ASP.NET Core Backend
│   ├── Controllers/        # API controllers
│   ├── Models/            # User, Crop, Fertilizer…
│   ├── Services/          # Business logic
│   ├── Data/              # EF Core DbContext
│   ├── Migrations/        # DB migrations
│   └── appsettings.json   # Config
│
├── SmartLand.AI/           # AI Models & Scripts
│   ├── chatbot/           # LLaMA3 fine-tuning
│   ├── soil_fertility/    # Random Forest training
│   ├── datasets/          # Training datasets
│   └── api/               # FastAPI deployment
│
└── SmartLand.sln           # Solution file
```

---

## 🚦 Getting Started

### 🔧 Prerequisites

* Flutter SDK (v3+)
* .NET SDK (v8+)
* Python 3.9+
* SQL Server (LocalDB/Express/Full)
* Git
* Hugging Face & Colab/Kaggle accounts

### ⚙️ Installation

```bash
# Clone repository
git clone https://github.com/yourusername/smart-land.git
cd smart-land
```

1. **Flutter**

   ```bash
   cd SmartLand.Mobile
   flutter pub get
   ```

2. **Backend**

   ```bash
   cd ../SmartLand.Backend
   dotnet restore
   ```

3. **AI Environment**

   ```bash
   cd ../SmartLand.AI
   python -m venv venv
   source venv/bin/activate   # On Windows: venv\Scripts\activate
   pip install -r requirements.txt
   ```

4. **Database** → Update connection in `appsettings.json`:

   ```json
   "ConnectionStrings": {
       "DefaultConnection": "Server=(localdb)\\mssqllocaldb;Database=SmartLandDB;Trusted_Connection=True;"
   }
   ```

5. **Run the project**

   ```bash
   # Backend
   cd SmartLand.Backend
   dotnet run

   # Frontend
   cd SmartLand.Mobile
   flutter run

   # AI API
   cd SmartLand.AI/api
   uvicorn main:app --reload
   ```

---

## 📚 API Endpoints

Base URL:

```
https://localhost:5001/api/v1
```

| Module             | Endpoints                                                                                            |
| ------------------ | ---------------------------------------------------------------------------------------------------- |
| **Auth**           | `POST /auth/register`, `POST /auth/login`, `POST /auth/forgot-password`, `POST /auth/reset-password` |
| **Chatbot**        | `POST /chatbot/query`, `GET /chatbot/history`                                                        |
| **Soil Analyzer**  | `POST /soil/analyze`, `GET /soil/history`                                                            |
| **Knowledge Base** | `GET /knowledge/crops`, `GET /knowledge/fertilizers`, `GET /knowledge/plants`, `GET /knowledge/faqs` |

👉 Full docs available at: **[Swagger](http://localhost:5001/swagger)**

---

## 👥 Team

| Name                                         | Role      | GitHub                                         |
| -------------------------------------------- | --------- | ---------------------------------------------- |
| Khaled Kamal Ali                             | Developer | [Profile](https://github.com/Khaled-Kamal)     |
| Nahla Mohammed Saeed                         | Developer | -                                              |
| Khalid Ghonem AbdLhamid                      | Developer | -                                              |
| Samar Basuny Haidar                          | Developer | -                                              |
| Gaber Mohammed Lotfi                         | Developer | -                                              |
| Esraa AbdElfttah Mohammed                    | Developer | [Profile](https://github.com/esraa-abdelfttah) |
| Hussien Talha Hussien                        | Developer | -                                              |
| Khaled Waled Mohammed                        | Developer | -                                              |
| **Supervisor**: Assoc. Prof. Reda M. Hussien | -         | -                                              |

---

## 📝 License

🎓 Graduation Project 2025, Faculty of Computers and Information – Kafr El-Sheikh University

---

## 📞 Support

* 📧 Email: **[KhaledKamal14t@outlook.sa](mailto:KhaledKamal14t@outlook.sa)**
* 📱 Phone: **01090662441**
* 📖 API Docs: [Swagger](http://localhost:5001/swagger)

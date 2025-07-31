# MentorAI Frontend

Frontend React application for MentorAI Virtual Teacher system.

## 🚀 Quick Start

### Prerequisites
- Node.js 18+ 
- npm or yarn

### Installation
```bash
npm install
```

### Development
```bash
npm run dev
```

The application will be available at `http://localhost:8080`

### Build
```bash
npm run build
```

## 🔧 Configuration

### Environment Variables
Create a `.env` file in the root directory:

```env
VITE_API_BASE_URL=http://localhost:5001/api
VITE_STRAICO_API_KEY=your_straico_api_key
VITE_ELEVENLABS_API_KEY=your_elevenlabs_api_key
```

### Backend Connection
This frontend connects to the MentorAI backend running on `http://localhost:5001`.

Make sure the backend is running before starting the frontend.

## 📁 Project Structure

```
src/
├── components/          # React components
│   ├── class-detail/   # Class detail components
│   └── ui/            # UI components
├── contexts/           # React contexts
├── hooks/             # Custom hooks
├── pages/             # Page components
├── services/          # API services
└── types/             # TypeScript types
```

## 🛠️ Technologies

- React 18
- TypeScript
- Vite
- Tailwind CSS
- Radix UI
- React Router
- Axios

## 📝 License

ISC 
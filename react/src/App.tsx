import React from 'react';
import { PrimeReactProvider } from 'primereact/api';
import StoryInteraction from './components/StoryInteraction';

// Import PrimeReact styles
import 'primereact/resources/primereact.min.css';
import 'primereact/resources/themes/vela-blue/theme.css';
import 'primeicons/primeicons.css';

// Import global styles
import './App.css';

function App() {
    return (
        <PrimeReactProvider>
            <div className="app-container">
                <StoryInteraction />
            </div>
        </PrimeReactProvider>
    );
}

export default App;
import React, { useEffect, useState } from 'react';
import './App.css';

function App() {
  const [apiHealth, setApiHealth] = useState(null);
  const [loading, setLoading] = useState(true);

  const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:8000';

  useEffect(() => {
    const checkApiHealth = async () => {
      try {
        const response = await fetch(`${API_URL}/health`);
        const data = await response.json();
        setApiHealth(data);
      } catch (error) {
        setApiHealth({ status: 'error', message: error.message });
      } finally {
        setLoading(false);
      }
    };

    checkApiHealth();
    const interval = setInterval(checkApiHealth, 10000); // Check every 10s
    return () => clearInterval(interval);
  }, [API_URL]);

  return (
    <div className="App">
      <header className="App-header">
        <h1>🎮 ft_transcendence</h1>
        <p>DevOps Infrastructure - Microservices Architecture</p>
        
        <div className="status-container">
          <h2>System Status</h2>
          
          <div className="service-status">
            <h3>Frontend</h3>
            <span className="status-badge success">✓ Running</span>
          </div>

          <div className="service-status">
            <h3>API Gateway</h3>
            {loading ? (
              <span className="status-badge loading">⟳ Checking...</span>
            ) : apiHealth?.status === 'healthy' ? (
              <span className="status-badge success">✓ Healthy</span>
            ) : (
              <span className="status-badge error">✗ Error</span>
            )}
          </div>

          <div className="service-status">
            <h3>Monitoring (Grafana)</h3>
            <a href="http://localhost:3001" target="_blank" rel="noopener noreferrer">
              <span className="status-badge info">→ Open Dashboard</span>
            </a>
          </div>

          <div className="service-status">
            <h3>Vault</h3>
            <a href="http://localhost:8200" target="_blank" rel="noopener noreferrer">
              <span className="status-badge info">→ Open Vault</span>
            </a>
          </div>
        </div>

        <div className="info-box">
          <h3>📋 Service Endpoints</h3>
          <ul>
            <li><strong>Frontend:</strong> http://localhost:3000</li>
            <li><strong>API Gateway:</strong> http://localhost:8000</li>
            <li><strong>API Docs:</strong> http://localhost:8000/docs</li>
            <li><strong>Prometheus:</strong> http://localhost:9090</li>
            <li><strong>Grafana:</strong> http://localhost:3001</li>
            <li><strong>Vault:</strong> http://localhost:8200</li>
          </ul>
        </div>
      </header>
    </div>
  );
}

export default App;

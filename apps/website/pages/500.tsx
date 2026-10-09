export default function Custom500() {
  return (
    <div style={{ minHeight: '100vh', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', background: '#0f172a', color: '#f8fafc', fontFamily: 'sans-serif' }}>
      <h1 style={{ fontSize: '2rem', fontWeight: 800, marginBottom: '0.5rem', color: '#10b981' }}>500 - Server Error</h1>
      <p style={{ color: '#94a3b8' }}>Something went wrong on our end. Please try refreshing.</p>
    </div>
  );
}

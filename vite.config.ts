import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    host: '0.0.0.0',  // <-- This is important
    port: 5173,       // <-- Vite runs on this
    strictPort: true  // <-- Avoid random ports
  }
})

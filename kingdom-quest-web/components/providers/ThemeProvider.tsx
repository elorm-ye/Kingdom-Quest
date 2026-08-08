'use client'

import { createContext, useContext, useEffect, useState, useCallback } from 'react'

export type ThemeName = 'default' | 'pink'

interface ThemeContextType {
  theme: ThemeName
  setTheme: (theme: ThemeName) => void
  toggleTheme: () => void
}

const ThemeContext = createContext<ThemeContextType | undefined>(undefined)

const STORAGE_KEY = 'kq-theme'

export function ThemeProvider({ children }: { children: React.ReactNode }) {
  const [theme, setThemeState] = useState<ThemeName>('default')
  const [mounted, setMounted] = useState(false)

  // Load saved theme on mount
  useEffect(() => {
    const saved = localStorage.getItem(STORAGE_KEY) as ThemeName | null
    if (saved && ['default', 'pink'].includes(saved)) {
      setThemeState(saved)
    }
    setMounted(true)
  }, [])

  // Apply theme class to <html> element
  useEffect(() => {
    if (!mounted) return
    const html = document.documentElement
    html.classList.remove('theme-default', 'theme-pink')
    html.classList.add(`theme-${theme}`)
  }, [theme, mounted])

  const setTheme = useCallback((t: ThemeName) => {
    setThemeState(t)
    localStorage.setItem(STORAGE_KEY, t)
  }, [])

  const toggleTheme = useCallback(() => {
    setTheme(theme === 'default' ? 'pink' : 'default')
  }, [theme, setTheme])

  return (
    <ThemeContext.Provider value={{ theme, setTheme, toggleTheme }}>
      {children}
    </ThemeContext.Provider>
  )
}

export function useTheme() {
  const ctx = useContext(ThemeContext)
  if (!ctx) throw new Error('useTheme must be used within ThemeProvider')
  return ctx
}

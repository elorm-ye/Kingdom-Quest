import MainLayout from '@/components/layout/MainLayout'
import InspirationPage from '@/components/pages/InspirationPage'

export const metadata = { title: 'Daily Inspiration' }

export default function Page() {
  return <MainLayout><InspirationPage /></MainLayout>
}

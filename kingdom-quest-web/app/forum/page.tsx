import MainLayout from '@/components/layout/MainLayout'
import ForumPage from '@/components/pages/ForumPage'

export const metadata = { title: 'Community Forum' }

export default function Page() {
  return <MainLayout><ForumPage /></MainLayout>
}

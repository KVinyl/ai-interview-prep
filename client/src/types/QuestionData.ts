import type { QuestionStatus } from './QuestionStatus'

export type QuestionData = {
  number: number;
  question: string;
  answer: string;
  feedback: string;
  status: QuestionStatus,
}
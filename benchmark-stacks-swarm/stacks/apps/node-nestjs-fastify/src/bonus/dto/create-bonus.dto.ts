import { IsNotEmpty, IsNumber, IsString, Min } from 'class-validator';

export class CreateBonusDto {
  @IsNumber()
  @Min(0.01)
  amount: number;

  @IsString()
  @IsNotEmpty()
  description: string;

  @IsString()
  @IsNotEmpty()
  clientId: string;
}
